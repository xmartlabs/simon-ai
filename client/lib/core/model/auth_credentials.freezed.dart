// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthCredentials _$AuthCredentialsFromJson(Map<String, dynamic> json) {
  return _AuthCredentials.fromJson(json);
}

/// @nodoc
mixin _$AuthCredentials {
  String get user => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthCredentialsCopyWith<AuthCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCredentialsCopyWith<$Res> {
  factory $AuthCredentialsCopyWith(
          AuthCredentials value, $Res Function(AuthCredentials) then) =
      _$AuthCredentialsCopyWithImpl<$Res, AuthCredentials>;
  @useResult
  $Res call({String user, String password});
}

/// @nodoc
class _$AuthCredentialsCopyWithImpl<$Res, $Val extends AuthCredentials>
    implements $AuthCredentialsCopyWith<$Res> {
  _$AuthCredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthCredentialsImplCopyWith<$Res>
    implements $AuthCredentialsCopyWith<$Res> {
  factory _$$AuthCredentialsImplCopyWith(_$AuthCredentialsImpl value,
          $Res Function(_$AuthCredentialsImpl) then) =
      __$$AuthCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user, String password});
}

/// @nodoc
class __$$AuthCredentialsImplCopyWithImpl<$Res>
    extends _$AuthCredentialsCopyWithImpl<$Res, _$AuthCredentialsImpl>
    implements _$$AuthCredentialsImplCopyWith<$Res> {
  __$$AuthCredentialsImplCopyWithImpl(
      _$AuthCredentialsImpl _value, $Res Function(_$AuthCredentialsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? password = null,
  }) {
    return _then(_$AuthCredentialsImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable()
class _$AuthCredentialsImpl implements _AuthCredentials {
  _$AuthCredentialsImpl({required this.user, required this.password});

  factory _$AuthCredentialsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthCredentialsImplFromJson(json);

  @override
  final String user;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthCredentials(user: $user, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthCredentialsImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthCredentialsImplCopyWith<_$AuthCredentialsImpl> get copyWith =>
      __$$AuthCredentialsImplCopyWithImpl<_$AuthCredentialsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthCredentialsImplToJson(
      this,
    );
  }
}

abstract class _AuthCredentials implements AuthCredentials {
  factory _AuthCredentials(
      {required final String user,
      required final String password}) = _$AuthCredentialsImpl;

  factory _AuthCredentials.fromJson(Map<String, dynamic> json) =
      _$AuthCredentialsImpl.fromJson;

  @override
  String get user;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$AuthCredentialsImplCopyWith<_$AuthCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
