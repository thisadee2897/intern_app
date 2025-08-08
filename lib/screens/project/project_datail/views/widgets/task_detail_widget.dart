import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
import 'package:project/components/export.dart';
import 'package:project/controllers/assignee_controller.dart';
import 'package:project/controllers/priority_controller.dart';
import 'package:project/controllers/task_status_controller.dart';
import 'package:project/controllers/type_of_work_controller.dart';
import 'package:project/models/priority_model.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/delete_comment_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_detail_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/detail_row_widget.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
import 'package:project/utils/extension/date_string_to_format_th.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/controllers/insert_comment_task_controller.dart';
import 'backlog_widget.dart';
import 'date_detail_row_widget.dart';

class TaskDetailWidget extends ConsumerStatefulWidget {
  const TaskDetailWidget({super.key});

  @override
  ConsumerState<TaskDetailWidget> createState() => _TaskDetailWidgetState();
}

class _TaskDetailWidgetState extends ConsumerState<TaskDetailWidget> {
  final QuillController _controller = QuillController.basic();
  final assigneeKey = GlobalKey<DropdownSearchState>();
  final priorityKey = GlobalKey<DropdownSearchState>();
  final taskStatusDownKey = GlobalKey<DropdownSearchState>();
  final typeOfWorkDownKey = GlobalKey<DropdownSearchState>();
  OverlayPortalController startDateController = OverlayPortalController();
  OverlayPortalController endDateController = OverlayPortalController();
  TextEditingController descriptionController = TextEditingController();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskDetail = ref.read(taskDetailProvider);
      if (taskDetail.value != null) {
        descriptionController.text = taskDetail.value!.description ?? '';
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskDetailProvider);
    final stateComment = ref.watch(commentTaskProvider);
    final insertState = ref.watch(insertCommentTaskControllerProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: ref.watch(showTaskDetailProvider) ? 495 : 0,
      height: double.infinity,
      color: Colors.white,
      child: state.when(
        data: (data) {
          return Column(
            children: [
              // Header with close button
              Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.name ?? 'Untitled Task', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref.read(showTaskDetailProvider.notifier).state = false;
                      },
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleForTask(title: 'Project', value: data.projectHd?.name ?? 'No Project'),
                        TitleForTask(title: 'Sprint', value: data.sprint?.name ?? 'No Sprint'),
                        Gap(12),
                        // Description section
                        Row(
                          children: [
                            const Text('Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.edit, size: 16),
                              onPressed: () {
                                // Handle edit action
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Text(
                        //   data.description?.isNotEmpty == true ? data.description! : 'Add a description...',
                        //   style: TextStyle(color: data.description?.isNotEmpty == true ? Colors.black87 : Colors.grey.shade600),
                        // ),
                        TextField(maxLines: 10, controller: descriptionController),
                        const SizedBox(height: 24),

                        // Details section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  Icon(Icons.settings, size: 16, color: Colors.grey.shade600),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Assignee
                              // _buildDetailRow('Assignee', data.assignedTo?.name ?? 'Unassigned', isAssignee: true, hasAssignee: data.assignedTo != null),
                              DetailRowWidget<String>(
                                title: 'Assignee',
                                dropDownKey: assigneeKey,
                                selectedItem: data.assignedTo?.name,
                                items: ref.watch(listAssignProvider).value!.map((e) => e.name!).toList(),
                                onSaved: (item) {
                                  UserModel assignee = ref.read(listAssignProvider).value!.firstWhere((e) => e.name == item);
                                  ref.read(taskDetailProvider.notifier).updateAssignee(assignee);
                                  // showSnackbar  item
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: $item')));
                                },
                              ),
                              DetailRowWidget<String>(
                                title: 'Priority',
                                dropDownKey: priorityKey,
                                selectedItem: data.priority?.name,
                                items: ref.watch(listPriorityProvider).value!.map((e) => e.name!).toList(),
                                onSaved: (item) {
                                  PriorityModel priority = ref.read(listPriorityProvider).value!.firstWhere((e) => e.name == item);
                                  ref.read(taskDetailProvider.notifier).updatePriority(priority);
                                  // showSnackbar  item
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: $item')));
                                },
                              ),
                              // Parent
                              DetailRowWidget<String>(
                                title: 'Task status',
                                dropDownKey: taskStatusDownKey,
                                selectedItem: data.taskStatus?.name,
                                items: ref.watch(listTaskStatusProvider).value!.map((e) => e.name!).toList(),
                                onSaved: (item) {
                                  TaskStatusModel taskStatus = ref.read(listTaskStatusProvider).value!.firstWhere((e) => e.name == item);
                                  ref.read(taskDetailProvider.notifier).updateTaskStatus(taskStatus);
                                  // showSnackbar  item
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: $item')));
                                },
                              ),
                              DetailRowWidget<String>(
                                title: 'Type Of Work',
                                dropDownKey: typeOfWorkDownKey,
                                selectedItem: data.typeOfWork!.name,
                                items: ref.watch(listTypeOfWorkProvider).value!.map((e) => e.name!).toList(),
                                onSaved: (value) {
                                  TypeOfWorkModel item = ref.read(listTypeOfWorkProvider).value!.firstWhere((e) => e.name == value);
                                  ref.read(taskDetailProvider.notifier).updateTypeOfWork(item);
                                },
                              ),
                              DateDetailRowWidget(title: 'Start Date', controller: startDateController, onDateSelected: (value) {}),
                              DateDetailRowWidget(title: 'End Date', controller: endDateController, onDateSelected: (value) {}),
                              _buildDetailRow('Created At', data.createdAt ?? 'None'),
                              //created_by
                              _buildDetailRow('Created By', data.createdBy?.name ?? 'Unknown'),
                              //active
                              _buildDetailRow('Active', data.active == true ? 'Yes' : 'No'),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              QuillSimpleToolbar(
                                controller: _controller,
                                config: QuillSimpleToolbarConfig(
                                  showItalicButton: false,
                                  showUnderLineButton: false,
                                  showSubscript: false,
                                  showSuperscript: false,
                                  showUndo: false,
                                  showRedo: false,
                                  showHeaderStyle: false,
                                  showBackgroundColorButton: false,
                                  showInlineCode: false,
                                  showSearchButton: false,
                                  showQuote: false,
                                  showFontFamily: false,
                                  showStrikeThrough: false,
                                  showIndent: false,
                                  showFontSize: false,
                                  showListBullets: false,
                                ),
                              ),
                              const SizedBox(height: 5),
                              StreamBuilder(
                                stream: _controller.document.changes,
                                builder: (context, snapshot) {
                                  double _getEditorHeight() {
                                    final plainText = _controller.document.toPlainText();
                                    final span = TextSpan(text: plainText, style: Theme.of(context).textTheme.bodyMedium);
                                    final tp = TextPainter(text: span, maxLines: 20, textDirection: TextDirection.ltr);
                                    tp.layout(maxWidth: MediaQuery.of(context).size.width - 32);
                                    double minHeight = 80;
                                    double maxHeight = 220;
                                    double contentHeight = tp.size.height + 32;
                                    if (contentHeight < minHeight) return minHeight;
                                    if (contentHeight > maxHeight) return maxHeight;
                                    return contentHeight;
                                  }

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 120),
                                    curve: Curves.ease,
                                    height: _getEditorHeight(),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                    child: QuillEditor(
                                      controller: _controller,
                                      focusNode: _editorFocusNode,
                                      scrollController: _editorScrollController,
                                      config: QuillEditorConfig(
                                        placeholder: 'พิมพ์ความคิดเห็น...',
                                        padding: const EdgeInsets.all(6),
                                        embedBuilders: [],
                                        scrollable: true,
                                        expands: false,
                                        searchConfig: QuillSearchConfig(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child:
                                    insertState.isLoading
                                        ? const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                                        )
                                        : ElevatedButton.icon(onPressed: _submitComment, icon: const Icon(Icons.send), label: const Text('ส่ง')),
                              ),
                            ],
                          ),
                        ),
                        stateComment.appWhen(
                          dataBuilder: (data) {
                            return ListView.builder(
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var item = data[index];
                                final controller = QuillController(
                                  document: Document.fromJson(item.commentJson!),
                                  selection: const TextSelection.collapsed(offset: 0),
                                  keepStyleOnNewLine: true,
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        child: Image.network(
                                          'https://cdn-icons-png.flaticon.com/512/8792/8792047.png',
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.createBy?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Tooltip(message: item.createdAt!.dateTimeTHFormApi, child: Text(timeago.format(DateTime.parse(item.createdAt!)))),
                                            // Text(item.createdAt.toString(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                            Container(
                                              margin: const EdgeInsets.only(top: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              child: QuillEditor(
                                                controller: controller,
                                                focusNode: FocusNode(),
                                                scrollController: ScrollController(),
                                                config: QuillEditorConfig(
                                                  padding: const EdgeInsets.all(12),
                                                  scrollable: false,
                                                  expands: false,
                                                  embedBuilders: [],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Confirm Delete'),
                                                        content: const Text('Are you sure you want to delete this comment?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () async {
                                                              Navigator.of(context).pop();
                                                              await ref.read(deleteCommentTaskControllerProvider.notifier).deleteComment(item.id!);
                                                              ref.read(commentTaskProvider.notifier).getCommentTask(state.value!.id!);
                                                            },
                                                            child: const Text('Delete'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stack) {
          print("Error fetching task details: $error");
          return Center(child: Text('Error: $error'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _submitComment() async {
    final deltaJson = _controller.document.toDelta().toJson();
    // เช็คว่ามีข้อความจริง
    final hasText = deltaJson.any((op) => op['insert'] != null && op['insert'].toString().trim().isNotEmpty);
    if (!hasText) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อความก่อนส่ง')));
      return;
    }

    final body = {
      "activity_id": "0",
      "project_hd_id": ref.read(selectProjectIdProvider),
      "master_type_of_work_id": "1",
      "comment": deltaJson,
      "task_id": ref.read(taskDetailProvider).value!.id,
    };
    await ref.read(insertCommentTaskControllerProvider.notifier).submit(body: body);
    final state = ref.read(insertCommentTaskControllerProvider);
    state.when(
      data: (message) async {
        _controller.clear();
        await Future.delayed(const Duration(milliseconds: 500));
        ref.read(commentTaskProvider.notifier).getCommentTask(ref.read(taskDetailProvider).value!.id!);
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAssignee = false, bool hasAssignee = false, bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 14))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAssignee && !hasAssignee) ...[
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(value, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  InkWell(onTap: () {}, child: const Text('Assign to me', style: TextStyle(color: Colors.blue, fontSize: 14))),
                ] else ...[
                  Text(
                    value,
                    style: TextStyle(
                      color: isHighlighted ? Colors.blue : Colors.black87,
                      fontSize: 14,
                      fontWeight: isHighlighted ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  if (isHighlighted && value.contains('Sprint')) const Text('+3', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
