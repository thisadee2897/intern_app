import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/screens/project/project_datail/providers/apis/project_api.dart';

class ProjectController {
  final Ref ref;
  ProjectController(this.ref);

  Future<List<ProjectHDModel>> getProjects({Map<String, dynamic>? params}) async {
    return await ref.read(apiProject).getProjects(params: params);
  }
}

final projectControllerProvider = Provider<ProjectController>((ref) => ProjectController(ref));
