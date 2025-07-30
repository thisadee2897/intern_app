import 'package:flutter/material.dart';
import 'package:project/components/export.dart';

import '../comment_task_screen.dart';

class BoardWidget extends BaseStatefulWidget {
  const BoardWidget({super.key});
  @override
  BaseState<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends BaseState<BoardWidget> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return CommentTaskScreen(projectId: '95',);
    // return Container(color: Colors.amber[50], child: Center(child: Text('Desktop View', style: Theme.of(context).textTheme.titleLarge)));
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return CommentTaskScreen(projectId: '95',);
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return CommentTaskScreen(projectId: '95',);
  }
}
