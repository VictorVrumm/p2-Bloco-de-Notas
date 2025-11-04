import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/bloc/note_bloc.dart';
import 'package:wow/data/models/note.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'note_edit_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
            tooltip: 'Editar nota',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'note_image_${note.id}',
                child: CachedNetworkImage(
                  imageUrl: note.category.imageUrl,
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 120,
                    color: colorScheme.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.broken_image, size: 80, color: colorScheme.error),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              note.title,
              style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              note.content,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categoria: ${note.category.name}',
                  style: textTheme.bodySmall,
                ),
                Text(
                  'Criado em: ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: textTheme.bodySmall,
                ),
                Icon(
                  note.isSynced ? Icons.cloud_done : Icons.cloud_upload_outlined,
                  color: note.isSynced ? Colors.green : Colors.orange,
                  size: 16,
                ),
                Text(
                  note.isSynced ? ' Sincronizado' : ' Pendente',
                  style: textTheme.bodySmall?.copyWith(
                      color: note.isSynced ? Colors.green : Colors.orange
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEdit(context),
        icon: const Icon(Icons.edit),
        label: const Text('Editar'),
      ),
    );
  }
}