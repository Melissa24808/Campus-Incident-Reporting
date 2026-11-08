import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/constants.dart';

class CategorySelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;
  final String? errorText;

  const CategorySelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
          childAspectRatio: 0.88,
          children: IncidentCategory.all.map((c) {
            final isSelected = c == selected;
            final color = IncidentCategory.colorFor(c);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onSelected(c),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : const Color(0xFFE9EAF2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.16)
                                : color.withValues(alpha: 0.13),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            IncidentCategory.iconFor(c),
                            color: isSelected ? Colors.white : color,
                            size: 31,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
