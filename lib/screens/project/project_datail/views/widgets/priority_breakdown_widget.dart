import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/controllers/piority_breakdown_controller.dart';

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
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Priority Breakdown', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('Get a holistic view of how work is being prioritized.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 8),
              Text('See what your team is focusing on', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue)),
            ],
          ),
        const SizedBox(height: 30),

          // กราฟ (ขึ้นอยู่กับ state)
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (priorities) => Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 5,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          ),
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
                                width: 35,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: priorities.map((p) {
                      return Text(
                        p.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}