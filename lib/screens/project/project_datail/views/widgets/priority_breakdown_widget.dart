import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriorityBreakdownWidget extends ConsumerStatefulWidget {
  const PriorityBreakdownWidget({super.key});

  @override
  ConsumerState<PriorityBreakdownWidget> createState() => _PriorityBreakdownWidgetState();
}

class _PriorityBreakdownWidgetState extends ConsumerState<PriorityBreakdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Priority breakdown', style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
