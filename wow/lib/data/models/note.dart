import 'package:equatable/equatable.dart';
import 'category.dart';
import 'note_status.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final Category category;
  final DateTime createdAt;
  final bool isSynced;
  final NoteStatus status;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.isSynced = false,
    this.status = NoteStatus.pending,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    Category? category,
    DateTime? createdAt,
    bool? isSynced,
    NoteStatus? status,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      status: status ?? this.status,
    );
  }

  // Adicionando toMap e fromMap para serialização
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isSynced': isSynced ? 1 : 0,
      'status': status.toJson(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: Category.fromMap(map['category']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isSynced: map['isSynced'] == 1,
      status: map['status'] != null
          ? NoteStatus.fromJson(map['status'])
          : NoteStatus.pending,
    );
  }

  @override
  List<Object?> get props => [id, title, content, category, createdAt, isSynced, status];
}