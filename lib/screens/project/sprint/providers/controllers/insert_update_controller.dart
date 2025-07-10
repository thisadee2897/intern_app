import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';

class InsertUpdateSprintNotifier extends StateNotifier<AsyncValue<SprintModel>> {
  InsertUpdateSprintNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;
  Future<void> get(SprintModel data) async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(data);
    } catch (e) {
      rethrow;
    }
  }

  // inert or update sprint
  Future<SprintModel> post({required Map<String, dynamic> body}) async {
    try {
      // Call your API to insert or update the sprint here
      // For example:
      // Response response = await ref.read(apiClientProvider).post('your_api_endpoint', data: body);
      // return SprintModel.fromJson(response.data);
      return SprintModel.fromJson(body); // Placeholder for actual API call
    } catch (e) {
      throw Exception('Failed to insert or update sprint: $e');
    }
  }
}

final insertUpdateSprintProvider = StateNotifierProvider<InsertUpdateSprintNotifier, AsyncValue<SprintModel>>((ref) => InsertUpdateSprintNotifier(ref));
