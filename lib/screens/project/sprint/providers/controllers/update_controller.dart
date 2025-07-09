import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';


class InsertOrUpdateSprintApi {
  final Ref ref;
  final String _path = 'project_data/insert_or_update_sprint';

  InsertOrUpdateSprintApi({required this.ref});

  Future<SprintModel> put({required Map<String, dynamic> body}) async {
    print(jsonEncode(body));
    try {
      final response = await ref.read(apiClientProvider).put(_path, data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return SprintModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertOrUpdateSprint = Provider<InsertOrUpdateSprintApi>((ref) => InsertOrUpdateSprintApi(ref: ref));


final updateSprintControllerProvider =
    StateNotifierProvider<UpdateSprintController, AsyncValue<SprintModel>>(
  (ref) => UpdateSprintController(ref: ref),
);

class UpdateSprintController extends StateNotifier<AsyncValue<SprintModel>> {
  final Ref ref;

  UpdateSprintController({required this.ref}) : super(const AsyncData(SprintModel()));

  Future<void> updateSprint({required Map<String, dynamic> body}) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(apiInsertOrUpdateSprint);
      final sprint = await api.put(body: body);
      state = AsyncData(sprint);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  void clearSprint() {
    state = const AsyncData(SprintModel());
  }
}
