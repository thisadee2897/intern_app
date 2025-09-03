import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/home/providers/apis/get_search_master_user.dart';


final searchDialogUserController =
    StateNotifierProvider<SearchDialogUserNotifier, AsyncValue<List<UserModel>>>(
  (ref) => SearchDialogUserNotifier(ref),
);

class SearchDialogUserNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final Ref ref;
  String _lastKeyword = ""; // เก็บ keyword ล่าสุดเพื่อ refresh

  SearchDialogUserNotifier(this.ref) : super(const AsyncValue.data([]));

  // ค้นหาผู้ใช้จาก API
  Future<void> search(String keyword) async {
    _lastKeyword = keyword;
    state = const AsyncValue.loading();
    try {
      final users = await ref.read(apiGetSearchMasterUser).get(keyword: keyword);
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // refresh state จาก keyword ล่าสุด
  Future<void> refresh() async {
    if (_lastKeyword.isNotEmpty) {
      await search(_lastKeyword);
    }
  }

  // ลบ user ออกจาก state ทันที (optimistic update)
  void removeUser(String userId) {
    state.whenData((users) {
      final updated = users.where((u) => u.id != userId).toList();
      state = AsyncValue.data(updated);
    });
  }

  // rollback user กลับเข้ามา (ถ้า API ล้มเหลว)
  void restoreUser(UserModel user) {
    state.whenData((users) {
      final updated = [...users, user];
      state = AsyncValue.data(updated);
    });
  }
}

