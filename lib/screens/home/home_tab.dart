import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../favorites/favorites_controller.dart';
import 'home_controller.dart';
import 'widgets/quote_card.dart';
import 'widgets/quote_of_day_card.dart';
import 'widgets/category_chip.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  final categories = const [
    'All',
    'Motivation',
    'Love',
    'Success',
    'Wisdom',
    'Humor',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesControllerProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final quotes = ref.watch(quotesProvider(selectedCategory));
    final quoteOfDay = ref.watch(quoteOfDayProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(quotesProvider(selectedCategory));
          ref.refresh(quoteOfDayProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote of the day
              quoteOfDay.when(
                data: (quote) => quote != null
                    ? QuoteOfDayCard(quote: quote)
                    : const SizedBox(),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text("Failed to load Quote of the Day"),
              ),

              const SizedBox(height: 16),

              // Categories
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final label = categories[index];
                    final isSelected =
                        selectedCategory == null && label == 'All' ||
                        selectedCategory == label;

                    return CategoryChip(
                      label: label,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            label == 'All' ? null : label;
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Quotes list
              quotes.when(
                data: (list) => list.isEmpty
                    ? const Text('No quotes found')
                    : Column(
                        children: list.map((q) {
                          final isFav = favoriteIds.contains(q.id);
                          return QuoteCard(
                            quote: q,
                            isFavorite: isFav,
                            onFavoriteTap: () {
                              ref
                                  .read(favoritesControllerProvider.notifier)
                                  .toggleFavorite(q.id);
                            },
                          );
                        }).toList(),
                      ),
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text("Error: $err"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
