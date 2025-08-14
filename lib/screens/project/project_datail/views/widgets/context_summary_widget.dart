import 'package:flutter/material.dart';
import 'package:project/models/project_over_view_model.dart';
import 'package:project/utils/extension/context_extension.dart';

enum IconType { completed, updated, created, dueSoon }

class ContextSummaryWidget extends StatelessWidget {
  final double width;
  final ProjectOverViewModel data;
  const ContextSummaryWidget({super.key, this.width = 300, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 50, height: 50, child: Center(child: Icon(_getIconData(data.icon!), color: context.primaryColor))),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('${data.count} ${data.title}', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text('${data.description}', style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getIconData(String iconType) {
    switch (iconType) {
      case 'completed':
        return Icons.check_circle;
      case 'updated':
        return Icons.update;
      case 'created':
        return Icons.check_box_outlined;
      case 'due_soon':
        return Icons.calendar_month_outlined;
    }
  }
}
