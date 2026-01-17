import 'package:flutter/material.dart';
import '../models/quote_model.dart';

enum QuoteCardStyle { style1, style2, style3 }

class QuoteCardImage extends StatelessWidget {
  final Quote quote;
  final QuoteCardStyle style;

  const QuoteCardImage({super.key, required this.quote, this.style = QuoteCardStyle.style1});

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case QuoteCardStyle.style2:
        return _buildStyle2();
      case QuoteCardStyle.style3:
        return _buildStyle3();
      default:
        return _buildStyle1();
    }
  }

  Widget _buildStyle1() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('"${quote.text}"', style: const TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          Text('- ${quote.author}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildStyle2() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('"${quote.text}"', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('- ${quote.author}', style: const TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStyle3() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade700, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('"${quote.text}"', style:  TextStyle(color: Colors.green.shade700, fontSize: 18)),
          const SizedBox(height: 8),
          Text('- ${quote.author}', style: TextStyle(color: Colors.green.shade700, fontSize: 14)),
        ],
      ),
    );
  }
}
