import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamWorkloadWidget extends ConsumerStatefulWidget {
  const TeamWorkloadWidget({super.key});

  @override
  ConsumerState<TeamWorkloadWidget> createState() => _TeamWorkloadWidgetState();
}

class _TeamWorkloadWidgetState extends ConsumerState<TeamWorkloadWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Center(child: Text('Team workload', style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
