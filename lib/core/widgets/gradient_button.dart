import 'package:flutter/material.dart';
import '../theme/app_gradient.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  const GradientButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        alignment: Alignment.center,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
