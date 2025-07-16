import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/apis/get_comment_api.dart';

final getCommentTaskControllerProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, taskId) async {
  final api = ref.read(apiGetCommentTaskProvider);
  return await api.get(taskId: taskId);
});
