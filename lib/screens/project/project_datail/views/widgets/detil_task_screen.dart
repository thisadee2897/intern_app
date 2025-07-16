import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อความก่อนส่ง')),
      );
      return;
    }

    final body = {
      "activity_id": "0", // ✅ ปรับตามข้อมูลจริงถ้ามี
      "project_hd_id": widget.task.projectHd?.id ?? "",
      "master_type_of_work_id": widget.task.typeOfWork?.id ?? "",
      "comment": [
        {"insert": text}
      ],
      "task_id": widget.task.id ?? "",
    };

    await ref.read(insertCommentTaskControllerProvider.notifier).submit(body: body);

    final state = ref.read(insertCommentTaskControllerProvider);
    state.when(
      data: (message) async {
        _commentController.clear();

        // ✅ แนะนำหน่วงเวลาเล็กน้อยเพื่อให้ API บันทึกก่อน
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
    print('== Watching comments for task_id: ${widget.task.id}');
    final comments = ref.watch(getCommentTaskControllerProvider(widget.task.id ?? ""));
    final insertState = ref.watch(insertCommentTaskControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('ความคิดเห็น - ${widget.task.name ?? ""}')),
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
                      final commentText = getPlainTextFromCommentJson(commentJson);
                      final createdAt = item['created_at'] ?? '';
                      final createdBy = item['create_by']?['name'] ?? '-';

                      return ListTile(
                        title: Text(commentText),
                        subtitle: Text('โดย $createdBy\n$createdAt'),
                        isThreeLine: true,
                        leading: const Icon(Icons.comment),
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
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'พิมพ์ความคิดเห็น...',
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                insertState.isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _submitComment,
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
