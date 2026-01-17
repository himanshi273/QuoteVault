import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../collections/add_to_collection_sheet.dart';
import '../models/quote_model.dart';
import '../services/share_service.dart';

class QuoteCard extends ConsumerWidget {
  final Quote quote;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const QuoteCard({
    super.key,
    required this.quote,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: isFavorite ? 12 : 8),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${quote.text}"',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '- ${quote.author}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.redAccent
                              : theme.iconTheme.color,
                        ),
                        onPressed: onFavoriteTap,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () async {
                          final key = GlobalKey();
                          await ShareService.shareWidget(key);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.playlist_add),
                        onPressed: () {
                          showAddToCollectionSheet(
                            context,
                            ref,
                            quote.id,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
