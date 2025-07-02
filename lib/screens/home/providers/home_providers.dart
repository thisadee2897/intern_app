import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/apis/home_api.dart';

// Provider สำหรับดึงข้อมูล workspace หลายรายการ (List)
final homeProvider = FutureProvider<List<WorkspaceModel>>((ref) async {
  return await ref.read(apiWorkSpace).fetch();
});