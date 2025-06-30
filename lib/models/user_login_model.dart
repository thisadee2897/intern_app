
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'user_login_model.freezed.dart';
part 'user_login_model.g.dart';

@freezed
class UserLoginModel with _$UserLoginModel {
  const factory UserLoginModel({
  @JsonKey(name: 'access_token') String? accessToken,
  @JsonKey(name: 'token_type') String? tokenType,
  @JsonKey(name: 'user') UserModel? user,
  }) = _UserLoginModel;

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => _$UserLoginModelFromJson(json);
}
