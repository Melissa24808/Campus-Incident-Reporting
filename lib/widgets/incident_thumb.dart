import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../utils/constants.dart';

/// Shows the incident photo if there is one, otherwise a category icon.
class IncidentThumb extends StatelessWidget {
  final Incident incident;
  final double size;

  const IncidentThumb({super.key, required this.incident, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: IncidentCategory.colorFor(incident.category)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        IncidentCategory.iconFor(incident.category),
        color: IncidentCategory.colorFor(incident.category),
        size: size * 0.45,
      ),
    );

    final url = incident.imageUrl;
    if (url == null || url.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}