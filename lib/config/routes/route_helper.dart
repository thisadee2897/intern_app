import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/config/routes/app_router.dart';

extension RouterHelperExtension on WidgetRef {
  goSubPath(String path, {Map<String, String>? params}) {
    Uri url = read(appRouterProvider).state.uri;
    Map<String, String> currentParams = Map<String, String>.from(url.queryParameters);
    if (params != null) currentParams.addAll(params);
    String currentPath = url.path;
    return read(appRouterProvider).go(Uri(path: "$currentPath/$path", queryParameters: currentParams).toString());
  }

  goFromPath(String path, {Map<String, String>? params}) {
    Uri url = read(appRouterProvider).state.uri;
    Map<String, String> currentParams = Map<String, String>.from(url.queryParameters);
    if (params != null) currentParams.addAll(params);
    return read(appRouterProvider).go(Uri(path: path, queryParameters: currentParams).toString());
  }

  goFromNotification(String path, {Map<String, String>? params}) {
    Uri url = read(appRouterProvider).state.uri;
    Map<String, String> currentParams = Map<String, String>.from(url.queryParameters);
    if (params != null) currentParams.addAll(params);
    return read(appRouterProvider).go(Uri(path: path, queryParameters: currentParams).toString());
  }
}
