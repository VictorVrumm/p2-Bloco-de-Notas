import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wow/data/models/note.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'notes_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, content TEXT, category TEXT, isSynced INTEGER, createdAt INTEGER)",
        );
      },
    );
  }

  // --- Operações CRUD para Notas ---

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      note.toMap()..['category'] = jsonEncode(note.category.toMap()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      final Map<String, dynamic> noteMap = Map.from(maps[i]);
      noteMap['category'] = jsonDecode(noteMap['category']);
      return Note.fromMap(noteMap);
    });
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap()..['category'] = jsonEncode(note.category.toMap()),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllNotes() async {
    final db = await database;
    await db.delete('notes');
  }
}