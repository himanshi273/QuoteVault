import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote_model.dart';

class HomeService {
  final _client = Supabase.instance.client;

  Future<List<Quote>> fetchQuotes({String? category, String? search}) async {
    try {
      var query = _client.from('quotes').select();

      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      if (search != null && search.isNotEmpty) {
        query = query.ilike('text', '%$search%');
      }

      final response =
      await query.order('created_at', ascending: false);

      final data = response as List<dynamic>;
      final quotes = data.map((e) => Quote.fromMap(e)).toList();

      // Debug print
      for (final quote in quotes) {
        print('[${quote.category}] ${quote.text}');
      }

      return quotes;
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }

  Future<Quote?> fetchQuoteOfDay() async {
    try {
      final today = DateTime.now().toIso8601String().split('T').first;

      // Check if today's quote exists
      final resp = await _client
          .from('daily_quote')
          .select('quote_id, date')
          .eq('date', today)
          .maybeSingle();

      String quoteId;

      if (resp == null) {
        // If not set, pick random quote
        // Get all quote IDs first, then pick one randomly
        final allQuotes = await _client.from('quotes').select('id');
        if (allQuotes.isEmpty) return null;
        final randomIndex = DateTime.now().millisecondsSinceEpoch % (allQuotes as List).length;
        quoteId = (allQuotes as List<dynamic>)[randomIndex]['id'];

        // Insert/update daily_quote table
        await _client.from('daily_quote').upsert({
          'id': 1,
          'quote_id': quoteId,
          'date': today,
        });
      } else {
        quoteId = resp['quote_id'];
      }

      final quoteResp = await _client.from('quotes').select().eq('id', quoteId).single();
      return Quote.fromMap(quoteResp);
    } catch (e) {
      return null;
    }
  }

}
