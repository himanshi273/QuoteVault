import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class QuoteOfDayCard extends StatelessWidget {
  final Quote quote;

  const QuoteOfDayCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quote of the Day',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"${quote.text}"',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '- ${quote.author}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
