import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';
import '../utils/format.dart';
import '../widgets/app_card.dart';
import '../widgets/incident_thumb.dart';
import '../widgets/status_chip.dart';
import '../widgets/status_timeline.dart';
import '../widgets/status_updater.dart';

class IncidentDetailsScreen extends StatelessWidget {
  final String incidentId;
  const IncidentDetailsScreen({super.key, required this.incidentId});

  Future<void> _confirmDelete(BuildContext context) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete report?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (sure != true || !context.mounted) return;

    final ok = await context.read<IncidentProvider>().delete(incidentId);
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete the report.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final incident = context.watch<IncidentProvider>().byId(incidentId);

    if (incident == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Incident Details')),
        body: const Center(child: Text('This report no longer exists.')),
      );
    }

    final isOwner = incident.reporterId == auth.appUser?.uid;
    final photo = incident.imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Details'),
        actions: [
          // Matches the security rule: only the owner, only while "Submitted".
          if (isOwner && incident.status == IncidentStatus.submitted)
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              tooltip: 'Delete report',
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IncidentThumb(incident: incident, size: 72),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incident.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${incident.category} · ${incident.location}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 8),
                          StatusChip(status: incident.status),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28),
                _InfoRow(
                  Icons.calendar_month_outlined,
                  'Submitted on ${formatDateTime(incident.createdAt)}',
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  Icons.account_circle_outlined,
                  'Reported by ${incident.reporterName}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Status Timeline'),
          AppCard(child: StatusTimeline(incident: incident)),
          const SizedBox(height: 24),
          const _SectionTitle('Description'),
          Text(incident.description, style: const TextStyle(height: 1.4)),
          if (photo != null && photo.isNotEmpty) ...[
            const SizedBox(height: 24),
            const _SectionTitle('Attached Photo'),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                photo,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 80,
                  child: Center(child: Text('Could not load the photo')),
                ),
              ),
            ),
          ],
          if (auth.isStaff) ...[
            const SizedBox(height: 24),
            AppCard(child: StatusUpdater(incident: incident)),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
