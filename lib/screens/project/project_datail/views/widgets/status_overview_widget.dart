import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusOverviewWidget extends ConsumerStatefulWidget {
  const StatusOverviewWidget({super.key});

  @override
  ConsumerState<StatusOverviewWidget> createState() => _StatusOverviewWidgetState();
}

class _StatusOverviewWidgetState extends ConsumerState<StatusOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Status overview', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 50))),
    );
  }
}
