import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_gradient.dart';
import '../home/widgets/quote_card.dart';
import '../home/models/quote_model.dart';
import 'favorites_controller.dart';

final favoriteQuotesProvider =
FutureProvider<List<Quote>>((ref) async {
  final client = Supabase.instance.client;
  final favoriteIds = ref.watch(favoritesControllerProvider);

  if (favoriteIds.isEmpty) return [];

  final response = await client
      .from('quotes')
      .select()
      .inFilter('id', favoriteIds.toList())
      .order('created_at', ascending: false);


  final data = response as List<dynamic>;
  return data.map((e) => Quote.fromMap(e)).toList();
});

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites ONCE
    Future.microtask(() {
      ref.read(favoritesControllerProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = ref.watch(favoritesControllerProvider);
    final favoriteQuotes = ref.watch(favoriteQuotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search (UI only for now)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // Stats Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${favoriteIds.length}\nFavorite Quotes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Favorites List
          Expanded(
            child: favoriteQuotes.when(
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (quotes) {
                if (quotes.isEmpty) {
                  return const Center(
                    child: Text('No favorites yet'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quotes.length,
                  itemBuilder: (_, i) {
                    final quote = quotes[i];
                    final isFav = favoriteIds.contains(quote.id);

                    return QuoteCard(
                      quote: quote,
                      isFavorite: isFav,
                      onFavoriteTap: () {
                        ref
                            .read(
                            favoritesControllerProvider.notifier)
                            .toggleFavorite(quote.id);
                      },
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
