import 'package:flutter/material.dart';

enum NoteStatus {
  pending,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case NoteStatus.pending:
        return 'Pendente';
      case NoteStatus.inProgress:
        return 'Em Andamento';
      case NoteStatus.completed:
        return 'Finalizado';
      case NoteStatus.cancelled:
        return 'Cancelado';
    }
  }

  Color get color {
    switch (this) {
      case NoteStatus.pending:
        return Colors.grey;
      case NoteStatus.inProgress:
        return Colors.orange;
      case NoteStatus.completed:
        return Colors.green;
      case NoteStatus.cancelled:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case NoteStatus.pending:
        return Icons.pending_outlined;
      case NoteStatus.inProgress:
        return Icons.sync;
      case NoteStatus.completed:
        return Icons.check_circle_outline;
      case NoteStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  // Para serialização
  String toJson() => name;

  static NoteStatus fromJson(String json) {
    return NoteStatus.values.firstWhere(
          (status) => status.name == json,
      orElse: () => NoteStatus.pending,
    );
  }
}