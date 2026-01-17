import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../favorites/favorites_controller.dart';
import '../home/models/quote_model.dart';
import '../home/widgets/quote_card.dart';
import 'collections_controller.dart';

class CollectionDetailsScreen extends ConsumerStatefulWidget {
  final Collection collection;

  const CollectionDetailsScreen({
    super.key,
    required this.collection,
  });

  @override
  ConsumerState<CollectionDetailsScreen> createState() =>
      _CollectionDetailsScreenState();
}

class _CollectionDetailsScreenState
    extends ConsumerState<CollectionDetailsScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final quotesAsync =
    ref.watch(collectionQuotesProvider(widget.collection.id));
    final favorites =
    ref.watch(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in collection...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (v) =>
                  setState(() => searchQuery = v),
            ),
          ),

          Expanded(
            child: quotesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (quotes) {
                final filtered = quotes.where((q) {
                  return q.text
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                      q.author
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No quotes found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final quote = filtered[i];
                    final isFav =
                    favorites.contains(quote.id);

                    return Row(
                      children: [
                        Expanded(
                          child: QuoteCard(
                            quote: quote,
                            isFavorite: isFav,
                            onFavoriteTap: () {
                              ref
                                  .read(
                                  favoritesControllerProvider
                                      .notifier)
                                  .toggleFavorite(quote.id);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                              Icons.remove_circle_outline),
                          onPressed: () async {
                            await ref
                                .read(
                                collectionsControllerProvider
                                    .notifier)
                                .removeQuoteFromCollection(
                              widget.collection.id,
                              quote.id,
                            );

                            ref.refresh(
                              collectionQuotesProvider(
                                  widget.collection.id),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
