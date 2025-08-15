// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TeamWorkloadWidget extends ConsumerStatefulWidget {
//   const TeamWorkloadWidget({super.key});

//   @override
//   ConsumerState<TeamWorkloadWidget> createState() => _TeamWorkloadWidgetState();
// }

// class _TeamWorkloadWidgetState extends ConsumerState<TeamWorkloadWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       height: 400, // Add some space between rows
//       decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
//       child: Center(child: Text('Team workload', style: Theme.of(context).textTheme.titleLarge)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/team_workload_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/team_workload_controller.dart';

class TeamWorkloadWidget extends ConsumerStatefulWidget {
  const TeamWorkloadWidget({super.key});

  @override
  ConsumerState<TeamWorkloadWidget> createState() => _TeamWorkloadWidgetState();
}

class _TeamWorkloadWidgetState extends ConsumerState<TeamWorkloadWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamWorkloadProvider.notifier).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workloadAsync = ref.watch(teamWorkloadProvider);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: workloadAsync.when(
        data: (items) => _buildContent(items, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text("Error: $e"),
      ),
    );
  }

  Widget _buildContent(List<TeamWorkloadModel> items, BuildContext context) {
    final totalCount = items.fold<num>(
      0,
      (sum, item) => sum + (item.count),
    );

    Color hexToColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex'; // เพิ่ม alpha
      return Color(int.parse(hex, radix: 16));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team workload",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: "Monitor the capacity of your team. ",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            children: [
              TextSpan(
                text: "Reassign work items to get the right balance",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "Assignee",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "Work distribution",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((member) {
          final percentage =
              totalCount == 0 ? 0.0 : (member.count / totalCount).toDouble();
          final memberColor = hexToColor(member.color ?? "#000000");

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14, // ขนาดวงกลม
                  backgroundColor: memberColor.withOpacity(0.3),
                  child: const Icon(Icons.person, color: Colors.black54, size: 20),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: Text(
                    member.name ?? "Unassigned",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                // หลอดอยู่ต่อจากชื่อ
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 14,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(memberColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${(percentage * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
