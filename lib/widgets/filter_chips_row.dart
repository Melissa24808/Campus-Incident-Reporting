import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// A horizontally scrolling row of chips. `selected == null` means "All".
class FilterChipsRow extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final String allLabel;

  const FilterChipsRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.allLabel = 'All',
  });

  Widget _chip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.secondary : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _chip(allLabel, selected == null, () => onSelected(null)),
          for (final o in options) _chip(o, selected == o, () => onSelected(o)),
        ],
      ),
    );
  }
}