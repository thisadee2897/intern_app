// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TypeOfWorkWidget extends ConsumerStatefulWidget {
//   const TypeOfWorkWidget({super.key});

//   @override
//   ConsumerState<TypeOfWorkWidget> createState() => _TypeOfWorkWidgetState();
// }

// class _TypeOfWorkWidgetState extends ConsumerState<TypeOfWorkWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       height: 400, // Add some space between rows
//       decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
//       child: Center(child: Text('Types of work', style: Theme.of(context).textTheme.titleLarge)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/type_of_work_controller.dart';

class TypeOfWorkWidget extends ConsumerStatefulWidget {
  const TypeOfWorkWidget({super.key});

  @override
  ConsumerState<TypeOfWorkWidget> createState() => _TypeOfWorkWidgetState();
}

class _TypeOfWorkWidgetState extends ConsumerState<TypeOfWorkWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardTypeOfWorkProvider.notifier).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final typeOfWorkAsync = ref.watch(dashboardTypeOfWorkProvider);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      height: 400, // Add some space between rows
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: typeOfWorkAsync.when(
        data: (items) => _buildContent(items, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text("Error: $e"),
      ),
    );
  }

  Widget _buildContent(List<TypeOfWorkModel> items, BuildContext context) {
    final totalCount = items.fold<num>(0, (sum, item) => sum + (item.count));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Types of work", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: "Get a breakdown of work items by their types. ",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            children: [TextSpan(text: "View all items", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500))],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text("Type", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700])),
            ),

            Expanded(
              flex: 3,
              child: Text("Distribution", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700])),
            ),
          ],
        ),

        Column(
          children:
              items.map((type) {
                final percentage = totalCount == 0 ? 0.0 : (type.count / totalCount).toDouble();
                final typeColor = Color(_hexToColor(type.color ?? "#000000"));

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12), // ระยะห่างเท่า TeamWorkload
                  child: Row(
                    children: [
                      _buildTypeIcon(type.name ?? "", type.color ?? "#000000", size: 38),
                      const SizedBox(width: 8),
                      SizedBox(width: 120, child: Text(type.name ?? "", style: const TextStyle(fontWeight: FontWeight.w500))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 30,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation(typeColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("${(percentage * 100).toStringAsFixed(0)}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeIcon(String name, String colorHex, {double size = 38}) {
    IconData icon;
    switch (name) {
      case "Task":
        icon = Icons.check_box;
        break;
      case "Epic":
        icon = Icons.flash_on;
        break;
      case "Request":
        icon = Icons.add_box;
        break;
      case "Bug":
        icon = Icons.bug_report;
        break;
      case "Feature":
        icon = Icons.grid_view;
        break;
      default:
        icon = Icons.work;
    }
    return Icon(icon, color: Color(_hexToColor(colorHex)), size: 30);
  }

  int _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return int.parse(hex, radix: 16);
  }
}
