import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/models/quote_model.dart';

class Collection {
  final String id;
  final String name;
  final String color;
  final List<Quote> quotes;

  Collection({required this.id, required this.name, required this.color, this.quotes = const []});

  factory Collection.fromMap(Map<String, dynamic> map) {
    final quotesData = map['collection_quotes'] as List<dynamic>? ?? [];
    return Collection(
      id: map['id'],
      name: map['name'],
      color: map['color'] ?? '#6750A4',
      quotes: quotesData.map((q) => Quote.fromMap(q['quotes'])).toList(),
    );
  }
}

final collectionsControllerProvider =
StateNotifierProvider<CollectionsController, AsyncValue<List<Collection>>>(
      (ref) => CollectionsController(),
);

final collectionQuotesProvider =
FutureProvider.family<List<Quote>, String>(
      (ref, collectionId) async {
    final client = Supabase.instance.client;

    // final response = await client
    //     .from('collection_quotes')
    //     .select('quotes(*)')
    //     .eq('collection_id', collectionId)
    //     .order('created_at');
    final response = await client
        .from('collection_quotes')
        .select('quotes(*)')
        .eq('collection_id', collectionId);

    final data = response as List<dynamic>;

    return data
        .map((e) => Quote.fromMap(e['quotes']))
        .toList();
  },
);


class CollectionsController
    extends StateNotifier<AsyncValue<List<Collection>>> {
  CollectionsController() : super(const AsyncLoading()) {
    loadCollections();
  }

  final _client = Supabase.instance.client;

  Future<void> loadCollections() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        state = const AsyncData([]);
        return;
      }

      final response = await _client
          .from('collections')
          .select()
          .eq('user_id', user.id) // 🔴 IMPORTANT
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      state = AsyncData(
        data.map((e) => Collection.fromMap(e)).toList(),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeQuoteFromCollection(
      String collectionId,
      String quoteId,
      ) async {
    try {
      await _client
          .from('collection_quotes')
          .delete()
          .eq('collection_id', collectionId)
          .eq('quote_id', quoteId);
    } catch (e) {
      throw Exception('Failed to remove quote from collection: $e');
    }
  }

  Future<void> addQuoteToCollection(
      String collectionId,
      String quoteId,
      ) async {
    try {
      await _client.from('collection_quotes').insert({
        'collection_id': collectionId,
        'quote_id': quoteId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // duplicate → ignore
        return;
      }
      rethrow;
    }
  }

  Future<void> createCollection(
      String name, {
        required String color,
      }) async {
    if (name.isEmpty) return;

    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('collections').insert({
      'name': name,
      'color': color,
      'user_id': user.id,
    });

    await loadCollections();
  }
}
