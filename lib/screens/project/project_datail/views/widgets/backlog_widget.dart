import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import '../../providers/controllers/delete_comment_controller.dart';
import '../../providers/controllers/master_task_status_controller.dart';
import 'backlog_group_widget.dart';

/// Provider สำหรับจัดการ Sprint ที่เลือก
final selectNextSprint = StateProvider<SprintModel?>((ref) => null);

/// Provider สำหรับจัดการวันที่เริ่มต้น Sprint
final formStartDateProvider = StateProvider<DateTime?>((ref) => null);

/// Provider สำหรับจัดการวันที่สิ้นสุด Sprint
final formEndDateProvider = StateProvider<DateTime?>((ref) => null);

class BacklogWidget extends BaseStatefulWidget {
  const BacklogWidget({super.key});
  @override
  BaseState<BacklogWidget> createState() => _BacklogWidgetState();
}

class _BacklogWidgetState extends BaseState<BacklogWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sprintProvider.notifier).get();
      _loadTasks();
    });

    super.initState();
  }

  /// โหลดรายการงานตาม projectHdId
  void _loadTasks() {
    ref.read(sprintProvider.notifier).get();
    ref.read(masterTaskStatusControllerProvider.notifier).fetchTaskStatuses();
    ref.read(dropDownSprintFormCompleteProvider.notifier).get();
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
