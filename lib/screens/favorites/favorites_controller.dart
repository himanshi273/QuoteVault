import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/models/quote_model.dart';

final favoritesControllerProvider =
StateNotifierProvider<FavoritesController, Set<String>>(
      (ref) => FavoritesController(),
);

class FavoritesController extends StateNotifier<Set<String>> {
  FavoritesController() : super({});

  final _client = Supabase.instance.client;

  Future<void> loadFavorites() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final resp = await _client
        .from('favorites')
        .select('quote_id')
        .eq('user_id', user.id);

    state = {
      for (final r in resp as List) r['quote_id'] as String,
    };
  }

  Future<void> toggleFavorite(String quoteId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    if (state.contains(quoteId)) {
      await _client
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('quote_id', quoteId);

      state = {...state}..remove(quoteId);
    } else {
      await _client.from('favorites').insert({
        'user_id': user.id,
        'quote_id': quoteId,
      });

      state = {...state, quoteId};
    }
  }
}
