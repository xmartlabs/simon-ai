// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      email: json['email'] as String,
      name: json['name'] as String?,
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'points': instance.points,
    };
