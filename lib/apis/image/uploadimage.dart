import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class UploadImageApi {
  final Ref ref;
  final String _path = 'image/upload_image';
  UploadImageApi({required this.ref});
  Future<String> post({required File file}) async {
    try {
      FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last)});
      Response response = await ref
          .read(apiClientProvider)
          .post(
            _path,
            data: formData,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data', // file image
              },
            ),
          );
      return response.data['path'] as String;
    } catch (e) {
      rethrow;
    }
  }
}

// Provider
final apiUploadImage = Provider<UploadImageApi>((ref) => UploadImageApi(ref: ref));

