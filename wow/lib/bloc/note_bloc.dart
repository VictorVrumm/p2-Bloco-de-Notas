import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:wow/data/models/note.dart';
import 'package:wow/utils/app_constants.dart';
import 'package:wow/bloc/note_event.dart';
import 'package:wow/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<ReorderNotes>(_onReorderNotes);
  }

  final Uuid _uuid = const Uuid();
  List<Note> _notes = [];

  void _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    _notes = [
      Note(
        id: _uuid.v4(),
        title: 'Lembrete de Compras',
        content: 'Comprar pão, leite, ovos, frutas e vegetais frescos.',
        category: AppConstants.categories[0],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isSynced: true,
      ),
      Note(
        id: _uuid.v4(),
        title: 'Ideias para o Projeto Flutter',
        content: 'Implementar animações, reordenamento de lista e tema escuro.',
        category: AppConstants.categories[1],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isSynced: false,
      ),
      Note(
        id: _uuid.v4(),
        title: 'Livros para Ler',
        content: 'Clean Code, The Pragmatic Programmer, Flutter in Action.',
        category: AppConstants.categories[2],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isSynced: true,
      ),
      Note(
        id: _uuid.v4(),
        title: 'Receita de Bolo',
        content: 'Farinha, açúcar, ovos, fermento. Assar a 180°C por 30min.',
        category: AppConstants.categories[0],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isSynced: false,
      ),
    ];
    emit(NoteLoaded(notes: List.from(_notes)));
  }

  void _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    if (state is NoteLoaded) {
      final currentNotes = List<Note>.from((state as NoteLoaded).notes);
      final newNote = Note(
        id: _uuid.v4(),
        title: event.title,
        content: event.content,
        category: AppConstants.categories.firstWhere((cat) => cat.id == event.categoryId),
        createdAt: DateTime.now(),
        isSynced: false,
      );
      currentNotes.insert(0, newNote);
      _notes = currentNotes;
      emit(NoteLoaded(notes: List.from(_notes)));
    }
  }

  void _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    if (state is NoteLoaded) {
      final currentNotes = List<Note>.from((state as NoteLoaded).notes);
      final noteIndex = currentNotes.indexWhere((note) => note.id == event.noteId);

      if (noteIndex != -1) {
        final updatedNote = currentNotes[noteIndex].copyWith(
          title: event.title,
          content: event.content,
          category: AppConstants.categories.firstWhere((cat) => cat.id == event.categoryId),
          isSynced: false,
        );
        currentNotes[noteIndex] = updatedNote;
        _notes = currentNotes;
        emit(NoteLoaded(notes: List.from(_notes)));
      }
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    if (state is NoteLoaded) {
      final currentNotes = List<Note>.from((state as NoteLoaded).notes);
      currentNotes.removeWhere((note) => note.id == event.noteId);
      _notes = currentNotes;
      emit(NoteLoaded(notes: List.from(_notes)));
    }
  }

  void _onReorderNotes(ReorderNotes event, Emitter<NoteState> emit) {
    if (state is NoteLoaded) {
      final List<Note> currentNotes = List.from((state as NoteLoaded).notes);
      int newIndex = event.newIndex;
      if (newIndex > event.oldIndex) {
        newIndex -= 1;
      }
      final Note item = currentNotes.removeAt(event.oldIndex);
      currentNotes.insert(newIndex, item);
      _notes = currentNotes;
      emit(NoteLoaded(notes: List.from(_notes)));
    }
  }
}