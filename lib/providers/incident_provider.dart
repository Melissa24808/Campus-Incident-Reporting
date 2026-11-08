import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../models/incident.dart';
import '../services/incident_service.dart';
import '../utils/constants.dart';

class IncidentProvider extends ChangeNotifier {
  final IncidentService _service;
  StreamSubscription<List<Incident>>? _sub;

  List<Incident> _all = [];
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  IncidentProvider(this._service);

  List<Incident> get incidents => _all;
  bool get loading => _loading;
  bool get submitting => _submitting;
  String? get error => _error;

  /// Called by the ProxyProvider whenever the login state changes.
  /// It runs during build, so it must not call notifyListeners().
  void onAuthChanged(bool active) {
    if (active && _sub == null) {
      _loading = true;
      _sub = _service.watchIncidents().listen(
        (data) {
          _all = data;
          _loading = false;
          _error = null;
          notifyListeners();
        },
        onError: (_) {
          _loading = false;
          _error = 'Could not load reports.';
          notifyListeners();
        },
      );
    } else if (!active && _sub != null) {
      _sub!.cancel();
      _sub = null;
      _all = [];
    }
  }

  /// Looks up one incident from the live list, so a screen that shows it
  /// updates automatically when the status changes.
  Incident? byId(String id) {
    for (final i in _all) {
      if (i.id == id) return i;
    }
    return null;
  }

  /// Search and filter. Every argument is optional.
  List<Incident> filtered({
    String query = '',
    String? status,
    String? category,
    String? reporterId,
  }) {
    final q = query.trim().toLowerCase();
    return _all.where((i) {
      if (reporterId != null && i.reporterId != reporterId) return false;
      if (status != null && i.status != status) return false;
      if (category != null && i.category != category) return false;
      if (q.isNotEmpty) {
        final text =
            '${i.title} ${i.description} ${i.location} ${i.category}'
                .toLowerCase();
        if (!text.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  int count({String? status, String? reporterId}) =>
      filtered(status: status, reporterId: reporterId).length;

  Future<bool> submit({
    required String title,
    required String description,
    required String category,
    required String location,
    required AppUser reporter,
    String? imageUrl,
  }) async {
    _submitting = true;
    _error = null;
    notifyListeners();
    try {
      final now = DateTime.now();
      await _service.create(Incident(
        id: '',
        title: title.trim(),
        description: description.trim(),
        category: category,
        location: location.trim(),
        status: IncidentStatus.submitted,
        reporterId: reporter.uid,
        reporterName: reporter.name,
        imageUrl: imageUrl,
        createdAt: now,
        updatedAt: now,
      ));
      return true;
    } catch (_) {
      _error = 'Could not submit the report. Please try again.';
      return false;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateStatus(String id, String status) async {
    _error = null;
    try {
      await _service.updateStatus(id, status);
      return true;
    } catch (_) {
      _error = 'Could not update the status.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    _error = null;
    try {
      await _service.delete(id);
      return true;
    } catch (_) {
      _error = 'Could not delete the report.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}