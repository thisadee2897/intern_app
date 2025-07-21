import 'package:flutter/material.dart';
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
  final TextEditingController _commentController = TextEditingController();

  String getPlainTextFromCommentJson(List<dynamic>? commentJson) {
    if (commentJson == null) return '-';
    return commentJson.map((e) => e['insert']?.toString() ?? '').join();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อความก่อนส่ง')));
      return;
    }

    final body = {
      "activity_id": "0",
      "project_hd_id": widget.task.projectHd?.id ?? "",
      "master_type_of_work_id": widget.task.typeOfWork?.id ?? "",
      "comment": [
        {"insert": text},
      ],
      "task_id": widget.task.id ?? "",
    };

    await ref
        .read(insertCommentTaskControllerProvider.notifier)
        .submit(body: body);

    final state = ref.read(insertCommentTaskControllerProvider);
    state.when(
      data: (message) async {
        _commentController.clear();
        await Future.delayed(const Duration(milliseconds: 500));
        ref.invalidate(getCommentTaskControllerProvider(widget.task.id ?? ""));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? "เพิ่มความคิดเห็นสำเร็จ")),
        );
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ฟังผลลบ comment ที่นี่
    ref.listen<DeleteCommentTaskState>(deleteCommentTaskControllerProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบความคิดเห็นไม่สำเร็จ: ${next.error}')),
        );
      } else if (next.message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));
        ref.invalidate(getCommentTaskControllerProvider(widget.task.id ?? ""));
      }

      // ✅ รีเซ็ต state หลังใช้งาน
      if (next.error != null || next.message != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            ref.read(deleteCommentTaskControllerProvider.notifier).state =
                DeleteCommentTaskState();
          }
        });
      }
    });

    final comments = ref.watch(
      getCommentTaskControllerProvider(widget.task.id ?? ""),
    );
    final insertState = ref.watch(insertCommentTaskControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ความคิดเห็น - ${widget.task.name ?? ""}'),
        backgroundColor: Color.fromARGB(255, 92, 179, 250),
      ),
      body: Column(
        children: [
          Expanded(
            child: comments.when(
              data: (list) {
                if (list is List) {
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final item = list[i];
                      final commentJson = item['comment_json'];
                      final commentText = getPlainTextFromCommentJson(
                        commentJson,
                      );
                      final createdAt = item['created_at'] ?? '';
                      final createdBy = item['create_by']?['name'] ?? '-';

                      return Card(
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: ListTile(
    contentPadding: const EdgeInsets.all(12),
    leading: CircleAvatar(
      backgroundColor: const Color.fromARGB(255, 92, 172, 250),
      child: Text(
        createdBy.isNotEmpty ? createdBy[0] : '?',
        style: const TextStyle(color: Colors.black),
      ),
    ),
    title: Text(
      commentText,
      style: const TextStyle(fontSize: 16),
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'โดย $createdBy',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            createdAt,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
    trailing: IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                                if (candidate != null &&
                                    candidate.toString().isNotEmpty) {
                                  activityId = candidate.toString();
                                  break;
                                }
                              }

                              if (activityId == null || activityId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'ไม่พบรหัสความคิดเห็นสำหรับลบ',
                                    ),
                                  ),
                                );
                                return;
                              }

                              await ref
                                  .read(
                                    deleteCommentTaskControllerProvider
                                        .notifier,
                                  )
                                  .deleteComment(activityId);
                            }
                          },
                        ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('ข้อมูล comment ไม่ใช่ List'),
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'พิมพ์ความคิดเห็น...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(width: 8),
                insertState.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 92, 172, 250),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _submitComment,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
