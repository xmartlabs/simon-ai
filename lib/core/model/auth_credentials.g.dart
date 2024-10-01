// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthCredentialsImpl _$$AuthCredentialsImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthCredentialsImpl(
      user: json['user'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$AuthCredentialsImplToJson(
        _$AuthCredentialsImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
    };
