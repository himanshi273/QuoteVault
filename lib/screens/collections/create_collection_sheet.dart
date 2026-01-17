import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/gradient_button.dart';
import 'collection_color_picker.dart';
import 'collections_controller.dart';

void showCreateCollectionSheet(BuildContext context, WidgetRef ref) {
  final nameController = TextEditingController();
  String selectedColor = '#6750A4';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create Collection',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Morning Motivation',
              ),
            ),

            const SizedBox(height: 16),

            CollectionColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (c) {
                setState(() => selectedColor = c);
              },
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    title: 'Create',
                    onTap: () async {
                      await ref
                          .read(
                          collectionsControllerProvider.notifier)
                          .createCollection(
                        nameController.text.trim(),
                        color: selectedColor,
                      );

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
