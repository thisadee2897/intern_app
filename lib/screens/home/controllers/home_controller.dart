import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/apis/home_api.dart';
import 'package:project/screens/home/providers/home_providers.dart';


class WorkSpaceNotifier extends StateNotifier<AsyncValue<List<WorkspaceModel>>> {
  WorkSpaceNotifier(this.ref) : super(const AsyncValue.data([]));
  final Ref ref;

  Future<void> fetchWorkspace() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final workspaces = await ref.read(apiWorkSpace).fetch();
        return workspaces;
      } catch (e) {
        rethrow;
      }
    });
  }

  void reset() {
    state = const AsyncValue.data([]);
  }
}

final workspaceProvider = StateNotifierProvider<WorkSpaceNotifier, AsyncValue<List<WorkspaceModel>>>(
  (ref) => WorkSpaceNotifier(ref),
);