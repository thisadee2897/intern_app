import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/status_overview.dart';

class StatusOverviewWidget extends ConsumerStatefulWidget {
  const StatusOverviewWidget({super.key});

  @override
  ConsumerState<StatusOverviewWidget> createState() => _StatusOverviewWidgetState();
}

class _StatusOverviewWidgetState extends ConsumerState<StatusOverviewWidget> {
  @override
  Widget build(BuildContext context) {
  // ดึงข้อมูล dummyStatusOverview มาใช้โดยตรง
  final data = dummyStatusOverview;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Overview', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('Get a snapshot of the status of your work items', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 8),
              Text('View all statuses', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.blue)),
            ],
          ),
        
          const SizedBox(height: 16),
          Expanded(
            child: Builder(
              builder: (context) {
                final data = dummyStatusOverview;
                final total = data.fold<int>(0, (sum, e) => sum + (e['count'] as int));
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 100,
                              sections: data.map((item) {
                                return PieChartSectionData(
                                  value: (item['count'] as int).toDouble(),
                                  color: _hexToColor(item['color'] as String? ?? '#cccccc'),
                                  title: '',
                                  radius: 40,
                                );
                              }).toList(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$total',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Text('Total work items'),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: data.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _hexToColor(item['color'] as String? ?? '#cccccc'),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item['name']}: ${item['count']}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}