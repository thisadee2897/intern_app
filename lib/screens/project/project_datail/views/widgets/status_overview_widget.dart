import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/controllers/status_overview.controller.dart';

class StatusOverviewWidget extends ConsumerStatefulWidget {
  const StatusOverviewWidget({super.key});

  @override
  ConsumerState<StatusOverviewWidget> createState() => _StatusOverviewWidgetState();
}

class _StatusOverviewWidgetState extends ConsumerState<StatusOverviewWidget> {
  int touchedIndex = -1;
  Offset? touchedPosition;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      ref.read(statusOverviewProvider.notifier).getData()
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusOverview = ref.watch(statusOverviewProvider);
    final data = statusOverview.when(
      data: (list) => list,
      loading: () => [],
      error: (err, stack) => [],
    );
  final total = data.isNotEmpty ? data.fold<int>(0, (sum, e) => sum + (e.count as int)) : 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      height: 400,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Overview', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('Get a snapshot of the status of your work items.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 8),
              Text('View all statuses', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: statusOverview.when(
              data: (list) {
                // Handle empty list case
                if (list.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No data available', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        response == null ||
                                        response.touchedSection == null) {
                                      touchedIndex = -1;
                                      touchedPosition = null;
                                      return;
                                    }
                                    touchedIndex = response.touchedSection!.touchedSectionIndex;
                                    touchedPosition = event.localPosition;
                                  });
                                },
                              ),
                              startDegreeOffset: 180,
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 2,
                              centerSpaceRadius: 80,
                              sections: List.generate(list.length, (i) {
                                final isTouched = i == touchedIndex;
                                return PieChartSectionData(
                                  color: _hexToColor(list[i].color ?? '#000000'),
                                  value: (list[i].count).toDouble(),
                                  title: '',
                                  radius: isTouched ? 65 : 50,
                                  borderSide: isTouched
                                      ? const BorderSide(color: Colors.white, width: 2)
                                      : BorderSide(color: Colors.white),
                                );
                              }),
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
                          ),
                          if (touchedIndex != -1 && touchedPosition != null)
                            Positioned(
                              left: touchedPosition!.dx,
                              top: touchedPosition!.dy - 40,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    '${list[touchedIndex].name ?? ''} (${list[touchedIndex].count})',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: list.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _hexToColor(item.color ?? '#cccccc'),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.name ?? ''}: ${item.count}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            ),
          ),
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