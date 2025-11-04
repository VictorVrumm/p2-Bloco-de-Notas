import 'package:wow/data/api/notes_api_service.dart';
import 'package:wow/data/database/database_helper.dart';
import 'package:wow/data/models/note.dart';

class NoteRepository {
  final DatabaseHelper _databaseHelper;
  final NotesApiService _apiService;

  NoteRepository(this._databaseHelper, this._apiService);

  // Carrega notas: tenta do DB, se não tiver ou for a primeira vez, sincroniza da API
  Future<List<Note>> loadNotes() async {
    List<Note> notes = [];
    try {
      notes = await _databaseHelper.getNotes();
      if (notes.isEmpty) {
        // Se não houver notas no DB, tenta da API
        print('No local notes, trying to fetch from API...');
        notes = await _apiService.fetchNotesFromApi();
        // Salva as notas da API no DB local
        for (var note in notes) {
          await _databaseHelper.insertNote(note.copyWith(isSynced: true));
        }
        print('Fetched notes from API and saved locally.');
        return notes;
      }
      print('Loaded notes from local database.');
      return notes;
    } catch (e) {
      print('Error loading notes: $e. Attempting to fetch from API as fallback.');
      // Se houver erro no DB ou para primeira carga, tenta da API
      notes = await _apiService.fetchNotesFromApi();
      for (var note in notes) {
        await _databaseHelper.insertNote(note.copyWith(isSynced: true));
      }
      print('Fetched notes from API (fallback) and saved locally.');
      return notes;
    }
  }

  // Sincroniza notas pendentes de upload com a API
  Future<void> syncNotes() async {
    final localNotes = await _databaseHelper.getNotes();
    final notesToSync = localNotes.where((note) => !note.isSynced).toList();

    for (var note in notesToSync) {
      try {
        final syncedNote = await _apiService.createNoteOnApi(note);
        await _databaseHelper.updateNote(syncedNote.copyWith(isSynced: true));
      } catch (e) {
        print('Failed to sync note ${note.id}: $e');
        // Tratar erro de sincronização (e.g., marcar como falha, tentar novamente)
      }
    }
    print('Sync process finished.');
  }

  Future<void> addNote(Note note) async {
    // Adiciona localmente primeiro, marca como não sincronizada
    await _databaseHelper.insertNote(note.copyWith(isSynced: false));
    // Tenta sincronizar imediatamente (ou pode ser feito em um processo em background)
    try {
      final syncedNote = await _apiService.createNoteOnApi(note);
      await _databaseHelper.updateNote(syncedNote.copyWith(isSynced: true));
    } catch (e) {
      print('Error syncing new note to API: $e');
      // Nota permanecerá como !isSynced, será sincronizada no próximo syncNotes()
    }
  }

  Future<void> updateNote(Note note) async {
    // Atualiza localmente e tenta na API
    await _databaseHelper.updateNote(note.copyWith(isSynced: false));
    try {
      final syncedNote = await _apiService.updateNoteOnApi(note);
      await _databaseHelper.updateNote(syncedNote.copyWith(isSynced: true));
    } catch (e) {
      print('Error syncing updated note to API: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    await _databaseHelper.deleteNote(id);
    try {
      await _apiService.deleteNoteOnApi(id);
    } catch (e) {
      print('Error syncing delete note to API: $e');
    }
  }
}