import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import '../../providers/controllers/project_over_view_controller.dart';
import 'context_summary_widget.dart';

class ProjectOverViewWidget extends BaseStatefulWidget {
  const ProjectOverViewWidget({super.key});

  @override
  BaseState<ProjectOverViewWidget> createState() => _ProjectOverViewWidgetState();
}

class _ProjectOverViewWidgetState extends BaseState<ProjectOverViewWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectOverViewProvider.notifier).getData();
    });
    super.initState();
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final state = ref.watch(projectOverViewProvider);
    return state.when(
      data: (data) {
        return SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal  ,
            child: Row(children: data.map((widget) => SizedBox(width: 350, child: ContextSummaryWidget(data: widget))).toList())),
        );
      },
      error: (err, stx) {
        return SizedBox(
          height: 100,
          child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))));
      },
      loading: () {
        return SizedBox(
          height: 100,
          child: const Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    throw UnimplementedError();
  }
}
