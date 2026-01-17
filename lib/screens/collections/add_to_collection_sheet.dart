import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collections_controller.dart';

void showAddToCollectionSheet(
    BuildContext context,
    WidgetRef ref,
    String quoteId,
    ) {
  // Ensure collections are loaded before opening
  ref.read(collectionsControllerProvider.notifier).loadCollections();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Consumer(
        builder: (context, ref, _) {
          final collectionsAsync =
          ref.watch(collectionsControllerProvider);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: collectionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Text('Error: $e'),
              ),
              data: (collections) {
                if (collections.isEmpty) {
                  return const Center(
                    child: Text('No collections found'),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add to Collection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...collections.map(
                          (c) => ListTile(
                        leading: Icon(
                          Icons.folder,
                          color: Color(
                            int.parse(
                              c.color.replaceFirst('#', '0xff'),
                            ),
                          ),
                        ),
                        title: Text(c.name),
                        onTap: () async {
                          await ref
                              .read(
                              collectionsControllerProvider
                                  .notifier)
                              .addQuoteToCollection(
                            c.id,
                            quoteId,
                          );

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );
}
