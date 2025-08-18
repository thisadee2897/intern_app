import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteImageApi {
  final Ref ref;
  final String _path = 'image/delete_image';
  DeleteImageApi({required this.ref});
  Future<String> post({required String imageUrl}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'image_url': imageUrl});
      return response.data['message'] as String;
    } catch (e) {
      rethrow;
    }
  }
}

// Provider
final apiDeleteImage = Provider<DeleteImageApi>((ref) => DeleteImageApi(ref: ref));
