import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;

  const StatTile({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text('$value',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}