import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:project/components/export.dart';
import 'package:project/config/routes/app_router.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/screens/auth/providers/controllers/auth_controller.dart';

import 'local_storage_service.dart';

const prod = 'https://inturn2025-815084861775.asia-southeast1.run.app/';
// const prod = 'http://127.0.0.1:8000/';
// const imageCheckIn = 'https://techcaresolution-ssl.com/oho-hrm/';

class ApiInterceptor extends Interceptor {
  final Ref ref;

  ApiInterceptor({required this.ref});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // var currentIPAddress = await ref.read(localStorageServiceProvider).getIPAddress();
    // print(currentIPAddress);
    String? token = await ref.read(localStorageServiceProvider).getToken();
    // String? token = '';
    options.headers["Authorization"] = "Bearer $token";
    options.headers["Accept-Language"] = 'th';
    // var lang = ref.read(languageProvider);
    // options.queryParameters = {...options.queryParameters, "lang": lang};
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 400) {
      handler.reject(
        DioException(
          type: DioExceptionType.badResponse,
          response: err.response,
          requestOptions: err.requestOptions,
          stackTrace: err.stackTrace,
          message: err.response?.data['detail'],
        ),
      );
      return;
    }
    if (err.response?.statusCode == 401) {
      // handler.reject(
      //   DioException(
      //     type: DioExceptionType.badResponse,
      //     response: err.response,
      //     requestOptions: err.requestOptions,
      //     stackTrace: err.stackTrace,
      //     message: err.response?.data['detail'] ?? 'Unauthorized',
      //   ),
      // );
      ref.read(localStorageServiceProvider).deleteToken();
      ref.read(localStorageServiceProvider).clear();
      ref.read(logoutProvider.future);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(appRouterProvider).go(Routes.login);
      });
      return;
    } else if (err.response?.statusCode == 404) {
      //404 หมายถึงไม่พบข้อมูล
      handler.reject(
        DioException(
          type: DioExceptionType.badResponse,
          response: err.response,
          requestOptions: err.requestOptions,
          stackTrace: err.stackTrace,
          message: "${err.response?.data}",
        ),
      );
      return;
    } else if (err.response?.statusCode == 422) {
      List<String> errors = [];
      if (err.response?.data['detail'] != null) {
        for (var item in err.response?.data['detail']) {
          var text = "${item['loc'][1]} :---> ${item['msg']}";
          errors.add(text);
        }
      }
      //ข้อมูลจะเป็นลิสต์ของข้อความ
      handler.reject(
        DioException(
          type: DioExceptionType.badResponse,
          response: err.response,
          requestOptions: err.requestOptions,
          stackTrace: err.stackTrace,
          message: errors.join('\n\n'),
        ),
      );
      return;
    } else {
      handler.reject(
        DioException(
          type: DioExceptionType.badResponse,
          response: err.response,
          requestOptions: err.requestOptions,
          stackTrace: err.stackTrace,
          message: 'Something went wrong',
        ),
      );
    }
  }
}

class ApiClient {
  Dio baseUrl(Ref<Dio> ref) {
    Dio dio = Dio();
    dio.options.baseUrl = prod;
    dio.interceptors.add(ApiInterceptor(ref: ref));
    return dio;
  }
}

final apiClientProvider = Provider<Dio>((ref) {
  try {
    return ApiClient().baseUrl(ref);
  } catch (e) {
    rethrow;
  }
});

void dioError(AsyncValue<dynamic> state) {
  if (state.hasError) {
    var error = state.error;
    if (error is DioException) {
      throw error.message!;
    }
  }
}
