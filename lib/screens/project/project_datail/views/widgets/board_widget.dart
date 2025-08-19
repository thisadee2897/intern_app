import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/project_datail/views/comment_task_screen.dart';

class BoardWidget extends BaseStatefulWidget {
  final String projectId; // <<< dynamic projectId
  const BoardWidget({super.key, required this.projectId});

  @override
  BaseState<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends BaseState<BoardWidget> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    // Debug: print projectId
    print('[BoardWidget] projectId: ${widget.projectId}');
    return CommentTaskScreen(projectId: widget.projectId);
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
  }
}