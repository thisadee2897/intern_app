import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/controllers/piority_breakdown_controller.dart';

class PriorityBreakdownWidget extends ConsumerStatefulWidget {
  const PriorityBreakdownWidget({super.key});

  @override
  ConsumerState<PriorityBreakdownWidget> createState() => _PriorityBreakdownWidgetState();
}

class _PriorityBreakdownWidgetState extends ConsumerState<PriorityBreakdownWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(piorityBreakdownProvider.notifier).getData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(piorityBreakdownProvider);
  return Container(
  margin: const EdgeInsets.symmetric(horizontal: 10),
  padding: const EdgeInsets.all(10),
  height: 400, 
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey, width: 1),
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Priority Breakdown',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),

      // Row(
      //   children: [
      //     Text(
      //       'Get a holistic view of how work is being prioritized.',
      //       style: Theme.of(context).textTheme.bodyMedium,
      //     ),
      //     const SizedBox(width: 8),
      //     Text(
      //       'See what your team is focusing on',
      //       style: Theme.of(context)
      //           .textTheme
      //           .bodyMedium!
      //           .copyWith(color: Colors.blue),
      //     ),
      //   ],
      // ),
      //เดิมใช้ Row → ไม่ responsive

      /// ใช้ Wrap ให้ responsive
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            'Get a holistic view of how work is being prioritized.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'See what your team is focusing on',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.blue),
          ),
        ],
      ),

      const SizedBox(height: 20),

      Expanded(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (priorities) {
            if (priorities.isEmpty) {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

          double barWidth = 60;
            return SizedBox(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < priorities.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                priorities[index].name ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: priorities.asMap().entries.map((entry) {
                    final index = entry.key;
                    final p = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: p.count.toDouble(),
                          color: _hexToColor(p.color ?? '#000000'),
                          width: barWidth,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
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
