import 'package:wow/data/models/note.dart';
import 'package:wow/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

class NotesApiService {
  // Simula um endpoint de API REST
  final String _baseUrl = 'https://mockapi.com/notes'; // Exemplo fictício

  // Simula um "banco de dados" remoto em memória
  final List<Note> _remoteNotes = [];
  final Uuid _uuid = const Uuid();

  NotesApiService() {
    // Adiciona algumas notas iniciais no "servidor remoto"
    _remoteNotes.add(Note(
        id: _uuid.v4(),
        title: 'Remote Note 1',
        content: 'This note is from the server.',
        category: AppConstants.categories[0],
        createdAt: DateTime.now(),
        isSynced: true
    ));
    _remoteNotes.add(Note(
        id: _uuid.v4(),
        title: 'Remote Note 2',
        content: 'Another server note.',
        category: AppConstants.categories[1],
        createdAt: DateTime.now(),
        isSynced: true
    ));
  }

  Future<List<Note>> fetchNotesFromApi() async {
    // Simula uma requisição GET
    await Future.delayed(const Duration(seconds: 2)); // Simula latência de rede
    print('Simulating fetching notes from API...');
    return _remoteNotes.map((note) => note.copyWith(isSynced: true)).toList();
  }

  Future<Note> createNoteOnApi(Note note) async {
    // Simula uma requisição POST
    await Future.delayed(const Duration(seconds: 1));
    final newId = _uuid.v4();
    final newNote = note.copyWith(id: newId, isSynced: true);
    _remoteNotes.add(newNote);
    print('Simulating creating note on API: ${newNote.title}');
    return newNote;
  }

  Future<Note> updateNoteOnApi(Note note) async {
    // Simula uma requisição PUT
    await Future.delayed(const Duration(seconds: 1));
    final index = _remoteNotes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      final updatedNote = note.copyWith(isSynced: true);
      _remoteNotes[index] = updatedNote;
      print('Simulating updating note on API: ${updatedNote.title}');
      return updatedNote;
    } else {
      throw Exception('Note not found on API for update');
    }
  }

  Future<void> deleteNoteOnApi(String id) async {
    // Simula uma requisição DELETE
    await Future.delayed(const Duration(seconds: 1));
    _remoteNotes.removeWhere((note) => note.id == id);
    print('Simulating deleting note on API: $id');
  }
}