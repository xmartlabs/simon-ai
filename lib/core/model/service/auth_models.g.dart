// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignInResponseImpl _$$SignInResponseImplFromJson(Map<String, dynamic> json) =>
    _$SignInResponseImpl(
      accessToken: json['access_token'] as String,
      user: Player.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SignInResponseImplToJson(
        _$SignInResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'user': instance.user.toJson(),
    };

_$SignInRequestImpl _$$SignInRequestImplFromJson(Map<String, dynamic> json) =>
    _$SignInRequestImpl(
      email: json['email'] as String,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$$SignInRequestImplToJson(_$SignInRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
    };
