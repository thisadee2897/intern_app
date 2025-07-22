import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';  
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/delete_comment_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/get_comment_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_comment_task_controller.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final TaskModel task;

  const CommentScreen({super.key, required this.task});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  // ใช้ QuillController สำหรับ rich text
  final QuillController _controller = QuillController.basic();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  String getPlainTextFromCommentJson(List<dynamic>? commentJson) {
    if (commentJson == null) return '-';
    return commentJson.map((e) => e['insert']?.toString() ?? '').join();
  }

  Future<void> _submitComment() async {
    final deltaJson = _controller.document.toDelta().toJson();
    // เช็คว่ามีข้อความจริง
    final hasText = deltaJson.any((op) => op['insert'] != null && op['insert'].toString().trim().isNotEmpty);
    if (!hasText) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อความก่อนส่ง')),
      );
      return;
    }

    final body = {
      "activity_id": "0",
      "project_hd_id": widget.task.projectHd?.id ?? "",
      "master_type_of_work_id": widget.task.typeOfWork?.id ?? "",
      "comment": deltaJson,
      "task_id": widget.task.id ?? "",
    };

    await ref.read(insertCommentTaskControllerProvider.notifier).submit(body: body);

    final state = ref.read(insertCommentTaskControllerProvider);
    state.when(
      data: (message) async {
        _controller.clear();
        await Future.delayed(const Duration(milliseconds: 500));
        ref.invalidate(getCommentTaskControllerProvider(widget.task.id ?? ""));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? "เพิ่มความคิดเห็นสำเร็จ")),
        );
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ฟังผลลบ comment ที่นี่
    ref.listen<DeleteCommentTaskState>(
      deleteCommentTaskControllerProvider,
      (previous, next) {
        if (!mounted) return;

        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ลบความคิดเห็นไม่สำเร็จ: ${next.error}')),
          );
        } else if (next.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message!)),
          );
          ref.invalidate(getCommentTaskControllerProvider(widget.task.id ?? ""));
        }

        // ✅ รีเซ็ต state หลังใช้งาน
        if (next.error != null || next.message != null) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              ref.read(deleteCommentTaskControllerProvider.notifier).state = DeleteCommentTaskState();
            }
          });
        }
      },
    );

    final comments = ref.watch(getCommentTaskControllerProvider(widget.task.id ?? ""));
    final insertState = ref.watch(insertCommentTaskControllerProvider);

    // --- Auto-grow logic for QuillEditor ---
    double _getEditorHeight() {
      // วัด plain text จาก document
      final plainText = _controller.document.toPlainText();
      final span = TextSpan(text: plainText, style: Theme.of(context).textTheme.bodyMedium);
      final tp = TextPainter(
        text: span,
        maxLines: 20,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: MediaQuery.of(context).size.width - 32); // padding 16*2
      double minHeight = 80;
      double maxHeight = 220;
      double contentHeight = tp.size.height + 32; // padding + toolbar
      if (contentHeight < minHeight) return minHeight;
      if (contentHeight > maxHeight) return maxHeight;
      return contentHeight;
    }

    return Scaffold(
      appBar: AppBar(title: Text('ความคิดเห็น - ${widget.task.name ?? ""}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                QuillSimpleToolbar(controller: _controller),
                const SizedBox(height: 5),
                StreamBuilder(
                  stream: _controller.document.changes,
                  builder: (context, snapshot) {
                    double _getEditorHeight() {
                      final plainText = _controller.document.toPlainText();
                      final span = TextSpan(text: plainText, style: Theme.of(context).textTheme.bodyMedium);
                      final tp = TextPainter(
                        text: span,
                        maxLines: 20,
                        textDirection: TextDirection.ltr,
                      );
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
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
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
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: insertState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _submitComment,
                          icon: const Icon(Icons.send),
                          label: const Text('ส่ง'),
                        ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: comments.when(
              data: (list) {
                if (list is List) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final commentJson = item['comment_json'];
                      final userName = item['create_by']?['name'] ?? 'User';
                      final createdAt = item['created_at'] ?? '';
                      final controller = QuillController(
                        document: Document.fromJson(commentJson),
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
                                  Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(createdAt, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('ยืนยันการลบ'),
                                            content: const Text('ต้องการลบความคิดเห็นนี้ใช่หรือไม่?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text('ยกเลิก'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: const Text('ลบ'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true) {
                                          final activityIdCandidates = [
                                            item['activity_id'],
                                            item['id'],
                                            item['comment_id'],
                                            item['task']?['id'],
                                            item['project']?['id'],
                                          ];
                                          String? activityId;
                                          for (final candidate in activityIdCandidates) {
                                            if (candidate != null && candidate.toString().isNotEmpty) {
                                              activityId = candidate.toString();
                                              break;
                                            }
                                          }
                                          if (activityId == null || activityId.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('ไม่พบรหัสความคิดเห็นสำหรับลบ')),
                                            );
                                            return;
                                          }
                                          await ref
                                              .read(deleteCommentTaskControllerProvider.notifier)
                                              .deleteComment(activityId);
                                        }
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
                } else {
                  return const Center(child: Text('ข้อมูล comment ไม่ใช่ List'));
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }
}
