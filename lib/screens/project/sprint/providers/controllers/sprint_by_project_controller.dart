// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:project/models/sprint_model.dart';
// // import 'package:project/components/export.dart';
// // import 'package:project/utils/services/rest_api_service.dart';


// // class SprintByProjectApi {
// //   final Ref ref;
// //   final String _path = 'project_data/get_sprint_by_project';

// //   SprintByProjectApi({required this.ref});

// //   Future<List<SprintModel>> get({required String projectId}) async {
// //     try {
// //       final response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_id': projectId});
// //       List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
// //       print(datas);
// //       return datas.map((e) => SprintModel.fromJson(e)).toList();
// //     } catch (e, stack) {
// //       print('hi: stack: $stack'); // Log the stack trace for debugging
// //       rethrow;
// //     }
// //   }
// // }

// // final apiSprintByProject = Provider<SprintByProjectApi>((ref) => SprintByProjectApi(ref: ref));


// // final sprintByProjectControllerProvider =
// //     StateNotifierProvider<SprintByProjectController, AsyncValue<List<SprintModel>>>(
// //   (ref) => SprintByProjectController(ref: ref),
// // );

// // class SprintByProjectController extends StateNotifier<AsyncValue<List<SprintModel>>> {
// //   final Ref ref;

// //   SprintByProjectController({required this.ref}) : super(const AsyncLoading());

// //   Future<void> getSprints(String projectId) async {
// //     state = const AsyncLoading();
// //     try {
// //       final api = ref.read(apiSprintByProject);
// //       final sprints = await api.get(projectId: projectId);
// //       state = AsyncData(sprints);
// //     } catch (e, stack) {
// //       state = AsyncError(e, stack);
// //     }
// //   }

// //   void clearSprints() {
// //     state = const AsyncData([]);
// //   }
// // }











// // 👉 Controller สำหรับดึง Sprint ทั้งหมดตาม Project
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dio/dio.dart';
// import 'package:project/models/sprint_model.dart';
// import 'package:project/utils/services/rest_api_service.dart';

// final sprintByProjectControllerProvider =
//     AsyncNotifierProvider<SprintByProjectController, List<SprintModel>>(
//   SprintByProjectController.new,
// );

// class SprintByProjectController extends AsyncNotifier<List<SprintModel>> {
//   @override
//   Future<List<SprintModel>> build() async {
//     return []; // ค่าเริ่มต้น เป็นลิสต์ว่าง
//   }

//   Future<void> getSprints(String projectId) async {
//     state = const AsyncLoading();
//     try {
//       final Response response = await ref.read(apiClientProvider).get(
//         'project_data/get_sprint_by_project',
//         queryParameters: {'project_id': projectId},
//       );

//       final List data = response.data as List;

//       state = AsyncData(data.map((e) => SprintModel.fromJson(e)).toList());
//     } catch (e, st) {
//       state = AsyncError(e, st);
//     }
//   }
// }




// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/models/sprint_model.dart';
// import 'package:project/screens/project/sprint/providers/api/sprint_by_project_api.dart';

// final sprintByProjectControllerProvider =
//     StateNotifierProvider<SprintByProjectController, AsyncValue<List<SprintModel>>>(
//   (ref) => SprintByProjectController(ref),
// );

// class SprintByProjectController extends StateNotifier<AsyncValue<List<SprintModel>>> {
//   final Ref ref;

//   SprintByProjectController(this.ref) : super(const AsyncLoading());

//   Future<void> getSprints(String projectId) async {
//     try {
//       state = const AsyncLoading();
//       final sprints = await ref.read(apiSprintByProject).get(projectId: projectId);
//       state = AsyncData(sprints);
//     } catch (e, st) {
//       state = AsyncError(e, st);
//     }
//   }
// }

