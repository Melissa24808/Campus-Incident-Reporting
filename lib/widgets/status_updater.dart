import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';

class StatusUpdater extends StatelessWidget {
  final Incident incident;
  const StatusUpdater({super.key, required this.incident});

  Future<void> _change(BuildContext context, String status) async {
    final provider = context.read<IncidentProvider>();
    final ok = await provider.updateStatus(incident.id, status);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            ok ? 'Status changed to $status' : (provider.error ?? 'Failed'))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Update status',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: IncidentStatus.all.map((s) {
            return ChoiceChip(
              label: Text(s),
              selected: incident.status == s,
              onSelected:
                  incident.status == s ? null : (_) => _change(context, s),
            );
          }).toList(),
        ),
      ],
    );
  }
}