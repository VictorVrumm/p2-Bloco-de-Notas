import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/bloc/note_bloc.dart';
import 'package:wow/bloc/note_event.dart';
import 'package:wow/bloc/note_state.dart';
import 'package:wow/data/models/note.dart';
import 'note_detail_screen.dart';
import 'package:wow/ui/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HomeScreen({Key? key, required this.themeModeNotifier}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WOW WOW'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeModeNotifier.value == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.themeModeNotifier.value =
              widget.themeModeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            final List<Note> notes = state.notes;

            if (notes.isEmpty) {
              return const Center(child: Text('Nenhuma nota ainda. Adicione uma!'));
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                final Note note = notes[index];
                return NoteCard(
                  key: ValueKey(note.id),
                  note: note,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(note: note),
                      ),
                    );
                  },
                  onDelete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nota "${note.title}" excluída!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    context.read<NoteBloc>().add(DeleteNote(noteId: note.id));
                  },
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                context.read<NoteBloc>().add(ReorderNotes(
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ));
              },
            );
          } else if (state is NoteError) {
            return Center(child: Text('Erro: ${state.message}'));
          }
          return const Center(child: Text('Carregando notas...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NoteBloc>().add(
            AddNote(
              title: 'Sem Título',
              content: 'Nova nota.',
              categoryId: '1',
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}