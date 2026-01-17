import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/home_service.dart';
import 'models/quote_model.dart';

final homeServiceProvider = Provider((ref) => HomeService());

final quotesProvider =
FutureProvider.family<List<Quote>, String?>((ref, category) async {
  final service = ref.watch(homeServiceProvider);

  final list = await service.fetchQuotes(
    category: category,
  );

  return list;
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
// null = ALL


final quoteOfDayProvider = FutureProvider<Quote?>((ref) async {
  final client = Supabase.instance.client;

  final today = DateTime.now();
  final todayDate =
  DateTime(today.year, today.month, today.day);

  // Try to get today's quote
  final dailyResp = await client
      .from('daily_quotes')
      .select('quote_id')
      .eq('day', todayDate.toIso8601String().split('T').first)
      .maybeSingle();

  String quoteId;

  if (dailyResp == null) {
    // Pick random quote
    final quotesResp =
    await client.from('quotes').select('id');

    final quotes = quotesResp as List<dynamic>;
    if (quotes.isEmpty) return null;

    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % quotes.length;

    quoteId = quotes[randomIndex]['id'];

    // Save for today
    await client.from('daily_quotes').insert({
      'quote_id': quoteId,
      'day': todayDate.toIso8601String().split('T').first,
    });
  } else {
    quoteId = dailyResp['quote_id'];
  }

  // Fetch full quote
  final quoteResp = await client
      .from('quotes')
      .select()
      .eq('id', quoteId)
      .single();

  return Quote.fromMap(quoteResp);
});

