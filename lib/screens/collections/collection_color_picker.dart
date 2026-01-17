import 'package:flutter/material.dart';

class CollectionColorPicker extends StatelessWidget {
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const CollectionColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  static const colors = [
    '#6750A4',
    '#006C4F',
    '#B3261E',
    '#0B57D0',
    '#7C4DFF',
    '#EF6C00',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: colors.map((hex) {
        final color = Color(
          int.parse(hex.replaceFirst('#', '0xff')),
        );

        final isSelected = hex == selectedColor;

        return GestureDetector(
          onTap: () => onColorSelected(hex),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
