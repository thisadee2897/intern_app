import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/project_datail/providers/backlog_group_controller.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'backlog_group_widget.dart';
import 'context_summary_widget.dart';

class BacklogWidget extends BaseStatefulWidget {
  const BacklogWidget({super.key});
  @override
  BaseState<BacklogWidget> createState() => _BacklogWidgetState();
}

class _BacklogWidgetState extends BaseState<BacklogWidget> {
  List<Widget> contextSummaryWidgets = [
    ContextSummaryWidget(title: 'Completed Tasks', count: '10'),
    ContextSummaryWidget(title: 'In Progress Tasks', count: '5'),
    ContextSummaryWidget(title: 'INPENDING', count: '2'),
    ContextSummaryWidget(title: 'Due soon', count: '3'),
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sprintProvider.notifier).get();
    });
    super.initState();
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final state = ref.watch(sprintProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.amber[50],
          child: state.when(
            data: (datas) {
              return ListView.builder(
                itemCount: datas.length + 1,
                itemBuilder: (context, index) {
                  if (index == datas.length) {
                    return BacklogGroupWidget(isExpanded: true);
                  } else {
                    SprintModel item = datas[index];
                    return BacklogGroupWidget(item: item);
                  }
                },
              );
            },
            error: (err, stx) {
              print("Error: ${err.toString()}");
              return Center(
                child: Text(
                  'Error: ${err.toString()}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    final data = ref.watch(mockupBacklogGroupProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.amber[50],
          child: ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == data.length) {
                return BacklogGroupWidget(isExpanded: true);
              }
              return BacklogGroupWidget();
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    final data = ref.watch(mockupBacklogGroupProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.amber[50],
          child: ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == data.length) {
                return BacklogGroupWidget(isExpanded: true);
              }
              return BacklogGroupWidget();
            },
          ),
        );
      },
    );
  }
}
