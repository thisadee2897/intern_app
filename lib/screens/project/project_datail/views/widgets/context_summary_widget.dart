import 'package:flutter/material.dart';
import 'package:project/utils/extension/context_extension.dart';

class ContextSummaryWidget extends StatelessWidget {
  final double width;
  final String title;
  final String count;
  const ContextSummaryWidget({super.key, this.width = 300, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: context.primaryColor, width: 1)),
        child: Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(width: 50, height: 50, color: Colors.red[100], child: Center(child: Text('icon', style: Theme.of(context).textTheme.titleLarge))),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('$count $title', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                  Text('in the last 7 days', style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
