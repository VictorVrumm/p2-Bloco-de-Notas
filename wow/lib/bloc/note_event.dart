import 'package:equatable/equatable.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final String title;
  final String content;
  final String categoryId;
  final String? status;

  const AddNote({
    required this.title,
    required this.content,
    required this.categoryId,
    this.status,
  });

  @override
  List<Object> get props => [title, content, categoryId];
}

class UpdateNote extends NoteEvent {
  final String noteId;
  final String title;
  final String content;
  final String categoryId;
  final String status;

  const UpdateNote({
    required this.noteId,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.status,
  });

  @override
  List<Object> get props => [noteId, title, content, categoryId, status];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  const DeleteNote({required this.noteId});

  @override
  List<Object> get props => [noteId];
}

class ReorderNotes extends NoteEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderNotes({
    required this.oldIndex,
    required this.newIndex
  });

  @override
  List<Object> get props => [oldIndex, newIndex];
}