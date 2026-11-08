import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/report_card.dart';

/// Browse all reports, with search and filters by status and category.
class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _status;
  String? _category;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<IncidentProvider>();
    final results = data.filtered(
      query: _query,
      status: _status,
      category: _category,
    );

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    Widget list;
    if (data.loading) {
      list = const Center(child: CircularProgressIndicator());
    } else if (data.error != null) {
      list = Center(child: Text(data.error!));
    } else if (results.isEmpty) {
      list = Center(
        child: Text(
          'No reports match your search.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    } else {
      list = ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount: results.length,
        itemBuilder: (_, i) => ReportCard(incident: results[i]),
      );
    }

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Track and review campus incidents',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${results.length}',
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search by title, location or description',
                prefixIcon: const Icon(Icons.manage_search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.backspace_outlined),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: border,
                enabledBorder: border,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilterChipsRow(
            options: IncidentStatus.all,
            selected: _status,
            allLabel: 'All status',
            onSelected: (s) => setState(() => _status = s),
          ),
          const SizedBox(height: 2),
          FilterChipsRow(
            options: IncidentCategory.all,
            selected: _category,
            allLabel: 'All categories',
            onSelected: (c) => setState(() => _category = c),
          ),
          const SizedBox(height: 2),
          Expanded(child: list),
        ],
      ),
    );
  }
}
