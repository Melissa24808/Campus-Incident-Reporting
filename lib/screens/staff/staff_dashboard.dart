import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/incident_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/report_card.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _status;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<IncidentProvider>();
    final reports = data.filtered(query: _query, status: _status);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(data: data),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search title, location...',
                prefixIcon: const Icon(Icons.manage_search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.backspace_outlined),
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          FilterChipsRow(
            options: IncidentStatus.all,
            selected: _status,
            allLabel: 'All',
            onSelected: (status) => setState(() => _status = status),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: data.loading
                ? const Center(child: CircularProgressIndicator())
                : data.error != null
                ? Center(child: Text(data.error!))
                : reports.isEmpty
                ? Center(
                    child: Text(
                      'No reports match your search.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: reports.length,
                    itemBuilder: (_, index) => ReportCard(
                      incident: reports[index],
                      showReporter: true,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final IncidentProvider data;

  const _Header({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: const BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Staff dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Review reports and update their status.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _Metric(
                icon: Icons.inventory_2_outlined,
                value: data.count(),
                label: 'All',
              ),
              _Metric(
                icon: Icons.fiber_new_rounded,
                value: data.count(status: IncidentStatus.submitted),
                label: 'New',
              ),
              _Metric(
                icon: Icons.pending_actions_rounded,
                value: data.count(status: IncidentStatus.inProgress),
                label: 'In progress',
              ),
              _Metric(
                icon: Icons.task_alt_rounded,
                value: data.count(status: IncidentStatus.resolved),
                label: 'Resolved',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _Metric({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
