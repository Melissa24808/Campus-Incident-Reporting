import 'package:flutter/material.dart';

import '../models/incident.dart';
import '../screens/incident_details_screen.dart';
import '../utils/format.dart';
import 'app_card.dart';
import 'incident_thumb.dart';
import 'status_chip.dart';

class ReportCard extends StatelessWidget {
  final Incident incident;
  final EdgeInsetsGeometry margin;
  final bool showReporter;

  const ReportCard({
    super.key,
    required this.incident,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    this.showReporter = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: margin,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => IncidentDetailsScreen(incidentId: incident.id),
        ),
      ),
      child: Row(
        children: [
          IncidentThumb(incident: incident, size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${incident.category} · ${incident.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      showReporter
                          ? Icons.account_circle_outlined
                          : Icons.history_toggle_off_rounded,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        showReporter
                            ? '${incident.reporterName} · ${timeAgo(incident.createdAt)}'
                            : timeAgo(incident.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusChip(status: incident.status),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
