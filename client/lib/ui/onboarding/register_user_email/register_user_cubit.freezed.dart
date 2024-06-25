// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_user_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegisterUserBaseState {
  String? get email => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? email, String? nickname, String error)
        state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? email, String? nickname, String error)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? email, String? nickname, String error)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterUserState value) state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterUserState value)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterUserState value)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterUserBaseStateCopyWith<RegisterUserBaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterUserBaseStateCopyWith<$Res> {
  factory $RegisterUserBaseStateCopyWith(RegisterUserBaseState value,
          $Res Function(RegisterUserBaseState) then) =
      _$RegisterUserBaseStateCopyWithImpl<$Res, RegisterUserBaseState>;
  @useResult
  $Res call({String? email, String? nickname, String error});
}

/// @nodoc
class _$RegisterUserBaseStateCopyWithImpl<$Res,
        $Val extends RegisterUserBaseState>
    implements $RegisterUserBaseStateCopyWith<$Res> {
  _$RegisterUserBaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? nickname = freezed,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterUserStateImplCopyWith<$Res>
    implements $RegisterUserBaseStateCopyWith<$Res> {
  factory _$$RegisterUserStateImplCopyWith(_$RegisterUserStateImpl value,
          $Res Function(_$RegisterUserStateImpl) then) =
      __$$RegisterUserStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? email, String? nickname, String error});
}

/// @nodoc
class __$$RegisterUserStateImplCopyWithImpl<$Res>
    extends _$RegisterUserBaseStateCopyWithImpl<$Res, _$RegisterUserStateImpl>
    implements _$$RegisterUserStateImplCopyWith<$Res> {
  __$$RegisterUserStateImplCopyWithImpl(_$RegisterUserStateImpl _value,
      $Res Function(_$RegisterUserStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? nickname = freezed,
    Object? error = null,
  }) {
    return _then(_$RegisterUserStateImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RegisterUserStateImpl implements RegisterUserState {
  const _$RegisterUserStateImpl(
      {required this.email, required this.nickname, required this.error});

  @override
  final String? email;
  @override
  final String? nickname;
  @override
  final String error;

  @override
  String toString() {
    return 'RegisterUserBaseState.state(email: $email, nickname: $nickname, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterUserStateImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, nickname, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterUserStateImplCopyWith<_$RegisterUserStateImpl> get copyWith =>
      __$$RegisterUserStateImplCopyWithImpl<_$RegisterUserStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? email, String? nickname, String error)
        state,
  }) {
    return state(email, nickname, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? email, String? nickname, String error)? state,
  }) {
    return state?.call(email, nickname, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? email, String? nickname, String error)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(email, nickname, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterUserState value) state,
  }) {
    return state(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterUserState value)? state,
  }) {
    return state?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterUserState value)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(this);
    }
    return orElse();
  }
}

abstract class RegisterUserState implements RegisterUserBaseState {
  const factory RegisterUserState(
      {required final String? email,
      required final String? nickname,
      required final String error}) = _$RegisterUserStateImpl;

  @override
  String? get email;
  @override
  String? get nickname;
  @override
  String get error;
  @override
  @JsonKey(ignore: true)
  _$$RegisterUserStateImplCopyWith<_$RegisterUserStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
