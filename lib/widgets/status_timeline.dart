import 'package:flutter/material.dart';

import '../models/incident.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/format.dart';

class StatusTimeline extends StatelessWidget {
  final Incident incident;
  const StatusTimeline({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    final steps = IncidentStatus.all;
    final current = steps.indexOf(incident.status);
    final color = AppTheme.statusColor(incident.status);
    const grey = Color(0xFFD9D9E3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final reached = i <= current;
        final showCheck =
            i < current || (i == current && i == steps.length - 1);

        String when = '';
        if (i == 0) {
          when = formatShort(incident.createdAt);
        } else if (i == current) {
          when = formatShort(incident.updatedAt);
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i == 0
                          ? Colors.transparent
                          : (i <= current ? color : grey),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: reached ? color : Colors.white,
                      border: Border.all(
                        color: reached ? color : grey,
                        width: 2,
                      ),
                    ),
                    child: showCheck
                        ? const Icon(
                            Icons.done_rounded,
                            size: 15,
                            color: Colors.white,
                          )
                        : reached
                        ? const Icon(Icons.circle, size: 8, color: Colors.white)
                        : null,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i == steps.length - 1
                          ? Colors.transparent
                          : (i < current ? color : grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                steps[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: i == current ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                when,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      }),
    );
  }
}
