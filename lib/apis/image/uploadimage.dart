import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class UploadImageApi {
  final Ref ref;
  final String _path = 'image/upload_image';

  UploadImageApi({required this.ref});

  Future<String> post({required File file}) async {
    try {
      print('Starting image upload for file: ${file.path}');
      
      // Check if file exists
      if (!await file.exists()) {
        throw Exception('File does not exist: ${file.path}');
      }
      
      // อ่านไฟล์ภาพ
      final bytes = await file.readAsBytes();
      print('File size: ${bytes.length} bytes');
      
      img.Image? image = img.decodeImage(bytes);
      if (image == null) throw Exception("Could not decode image");
      
      print('Image decoded successfully: ${image.width}x${image.height}');
      
      // ตรวจสอบความกว้างและสูง และปรับขนาดถ้าเกิน 1024
      if (image.width > 1024 || image.height > 1024) {
        print('Resizing image from ${image.width}x${image.height}');
        if (image.width >= image.height) {
          final newHeight = (image.height * 1024 / image.width).round();
          image = img.copyResize(image, width: 1024, height: newHeight);
        } else {
          final newWidth = (image.width * 1024 / image.height).round();
          image = img.copyResize(image, width: newWidth, height: 1024);
        }
        print('Image resized to: ${image.width}x${image.height}');
      }
      
      // เขียนไฟล์ใหม่ลง temp
      final tempPath = '${file.parent.path}/temp_${file.path.split('/').last}';
      final tempFile = File(tempPath);
      final jpgBytes = img.encodeJpg(image, quality: 100);
      await tempFile.writeAsBytes(jpgBytes);
      
      print('Temp file created: ${tempFile.path}, size: ${jpgBytes.length} bytes');
      
      // สร้าง FormData
      String filename = file.path.split('/').last;
      // Ensure the filename has a proper image extension
      if (!filename.toLowerCase().endsWith('.jpg') && 
          !filename.toLowerCase().endsWith('.jpeg') && 
          !filename.toLowerCase().endsWith('.png')) {
        filename = '$filename.jpg';
      }
      
      print('Upload filename: $filename');
      
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          tempFile.path,
          filename: filename,
          contentType: MediaType('image', 'jpeg'), // Explicitly set content type
        ),
      });
      // เรียก API
      print('Making API call to: $_path');
      Response response = await ref
          .read(apiClientProvider)
          .post(
            _path,
            data: formData,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data',
              },
            ),
          );
      // ลบ temp file หลังอัปโหลด
      await tempFile.delete();
      return response.data['path'] as String;
    } catch (e) {
      print('Upload API error: $e');
      rethrow;
    }
  }
}

// Provider
final apiUploadImage = Provider<UploadImageApi>((ref) => UploadImageApi(ref: ref));
