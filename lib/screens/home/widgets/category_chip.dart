import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
