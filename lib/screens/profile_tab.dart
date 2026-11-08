import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/incident.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/app_card.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/report_card.dart';
import '../widgets/stat_tile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? _status;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<IncidentProvider>();
    final user = auth.appUser;
    final uid = user?.uid;

    final mine = uid == null
        ? <Incident>[]
        : data.filtered(reporterId: uid, status: _status);

    final name = user?.name ?? '';
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: 'Log out',
                  onPressed: auth.logout,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            auth.isStaff ? 'Staff' : 'Student',
                            style: const TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user?.email ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.summarize_outlined,
                    color: AppTheme.secondary,
                    value: data.count(reporterId: uid),
                    label: 'Total Reports',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    icon: Icons.hourglass_top_rounded,
                    color: AppTheme.statusColor(IncidentStatus.inProgress),
                    value: data.count(
                      status: IncidentStatus.inProgress,
                      reporterId: uid,
                    ),
                    label: 'In Progress',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    icon: Icons.task_alt_rounded,
                    color: AppTheme.statusColor(IncidentStatus.resolved),
                    value: data.count(
                      status: IncidentStatus.resolved,
                      reporterId: uid,
                    ),
                    label: 'Resolved',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              'My Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          FilterChipsRow(
            options: IncidentStatus.all,
            selected: _status,
            onSelected: (s) => setState(() => _status = s),
          ),
          const SizedBox(height: 8),
          if (mine.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'You have no reports here yet.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            ...mine.map((i) => ReportCard(incident: i)),
        ],
      ),
    );
  }
}
