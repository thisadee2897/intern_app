import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_project_category_and_projects_by_user.dart';
import 'package:project/apis/project_data/get_project_category_unique_name.dart';
import 'package:project/models/category_model.dart';

final categoryProvider = StateNotifierProvider<CategotyNotifier, AsyncValue<List<CategoryModel>>>((ref) => CategotyNotifier(ref));

class CategotyNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final Ref ref;
  CategotyNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> getCategory(String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiProjectCategoryAndProjectsByUser).get(workspaceId: id);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}












// Validation and state management for category name input
final categoryNameProvider = StateProvider<String>((ref) => '');
final categoryNameErrorProvider = StateProvider<String?>((ref) => null);

final checkTextCategoryUniqueNameProvider = FutureProvider.autoDispose<void>((ref) async {
  final name = ref.watch(categoryNameProvider);
  if (name.isEmpty) {
    ref.read(categoryNameErrorProvider.notifier).state = 'ห้ามเว้นว่าง';
  } else {
    final response = await ref.read(apiProjectCategoryUniqueName).get(testSearch: name);
    ref.read(categoryNameErrorProvider.notifier).state =
        response.isEmpty ? null : 'ชื่อหมวดหมู่นี้ถูกใช้แล้ว';
  }
});
