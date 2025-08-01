import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
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
          child: state.when(
            data: (datas) {
              return ListView.builder(
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  SprintModel item = datas[index];
                  return BacklogGroupWidget(item: item);
                  // if (index == datas.length) {
                  //   // ส่ง item: null เพื่อแสดง backlog group (ไม่มี sprint)
                  //   // return BacklogGroupWidget(isExpanded: true, item: null);
                  // } else {
                  //   SprintModel item = datas[index];
                  //   return BacklogGroupWidget(item: item);
                  // }
                },
              );
            },
            error: (err, stx) => Center(child: Text('Error: ${err.toString()}', style: const TextStyle(color: Colors.red))),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return buildDesktop(context, sizingInformation);
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return buildDesktop(context, sizingInformation);
  }
}
