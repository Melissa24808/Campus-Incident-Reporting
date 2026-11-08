import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/report_card.dart';
import '../widgets/section_header.dart';
import 'student/submit_incident_screen.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onSeeAll;

  const HomeTab({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<IncidentProvider>();
    final user = auth.appUser;
    final scopeId = auth.isStaff ? null : user?.uid;
    final recent = data.filtered(reporterId: scopeId).take(3).toList();
    final firstName = (user?.name ?? '').trim().split(' ').first;
    final initial = firstName.isEmpty ? '?' : firstName[0].toUpperCase();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          _StudentHeader(firstName: firstName, initial: initial),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _ReportBanner(),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Report summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ReportSummary(data: data, scopeId: scopeId),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(title: 'Recent reports', onSeeAll: onSeeAll),
          ),
          if (data.loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (data.error != null)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(data.error!)),
            )
          else if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No reports yet. Tap + to add one.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            ...recent.map((incident) => ReportCard(incident: incident)),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Quick report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _QuickCategories(onTap: (_) => _openReport(context)),
        ],
      ),
    );
  }

  static void _openReport(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SubmitIncidentScreen()));
  }
}

class _StudentHeader extends StatelessWidget {
  final String firstName;
  final String initial;

  const _StudentHeader({required this.firstName, required this.initial});

  @override
  Widget build(BuildContext context) {
    final greetingName = firstName.isEmpty ? 'there' : firstName;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $greetingName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Help make our campus safer.',
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Report issues and track their resolution.',
                  style: TextStyle(
                    color: AppTheme.secondary.withValues(alpha: 0.62),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          CircleAvatar(
            radius: 25,
            backgroundColor: AppTheme.surfaceTint,
            child: Text(
              initial,
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportSummary extends StatelessWidget {
  final IncidentProvider data;
  final String? scopeId;

  const _ReportSummary({required this.data, required this.scopeId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _SummaryTile(
            icon: Icons.description_outlined,
            value: data.count(reporterId: scopeId),
            label: 'My Reports',
            color: AppTheme.primary,
          ),
          const SizedBox(width: 8),
          _SummaryTile(
            icon: Icons.pending_actions_rounded,
            value: data.count(
              status: IncidentStatus.inProgress,
              reporterId: scopeId,
            ),
            label: 'In Progress',
            color: const Color(0xFF2674E8),
          ),
          const SizedBox(width: 8),
          _SummaryTile(
            icon: Icons.task_alt_rounded,
            value: data.count(
              status: IncidentStatus.resolved,
              reporterId: scopeId,
            ),
            label: 'Resolved',
            color: const Color(0xFF23A678),
          ),
          const SizedBox(width: 8),
          _SummaryTile(
            icon: Icons.fiber_new_rounded,
            value: data.count(
              status: IncidentStatus.submitted,
              reporterId: scopeId,
            ),
            label: 'Submitted',
            color: const Color(0xFFE45A73),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;

  const _SummaryTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 7),
            Text(
              '$value',
              style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondary.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportBanner extends StatelessWidget {
  const _ReportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7047F8), Color(0xFF9478FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: 12,
            child: Icon(
              Icons.account_balance_rounded,
              size: 126,
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            right: 68,
            bottom: 56,
            child: Icon(
              Icons.park_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'See an issue\non campus?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Report it and help improve\nour learning environment.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => HomeTab._openReport(context),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primary,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Report an issue',
                              style: TextStyle(
                                color: AppTheme.secondary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppTheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCategories extends StatelessWidget {
  final ValueChanged<String> onTap;

  const _QuickCategories({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: IncidentCategory.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          final category = IncidentCategory.all[index];
          final color = IncidentCategory.colorFor(category);
          return GestureDetector(
            onTap: () => onTap(category),
            child: SizedBox(
              width: 92,
              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IncidentCategory.iconFor(category),
                          color: color,
                          size: 29,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
