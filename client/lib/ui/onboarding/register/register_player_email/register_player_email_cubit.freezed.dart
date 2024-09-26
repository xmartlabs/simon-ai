// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_player_email_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegisterPlayerEmailBaseState {
  String? get email => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? email) state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? email)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? email)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterPlayerEmailState value) state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterPlayerEmailState value)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterPlayerEmailState value)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterPlayerEmailBaseStateCopyWith<RegisterPlayerEmailBaseState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterPlayerEmailBaseStateCopyWith<$Res> {
  factory $RegisterPlayerEmailBaseStateCopyWith(
          RegisterPlayerEmailBaseState value,
          $Res Function(RegisterPlayerEmailBaseState) then) =
      _$RegisterPlayerEmailBaseStateCopyWithImpl<$Res,
          RegisterPlayerEmailBaseState>;
  @useResult
  $Res call({String? email});
}

/// @nodoc
class _$RegisterPlayerEmailBaseStateCopyWithImpl<$Res,
        $Val extends RegisterPlayerEmailBaseState>
    implements $RegisterPlayerEmailBaseStateCopyWith<$Res> {
  _$RegisterPlayerEmailBaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterPlayerEmailStateImplCopyWith<$Res>
    implements $RegisterPlayerEmailBaseStateCopyWith<$Res> {
  factory _$$RegisterPlayerEmailStateImplCopyWith(
          _$RegisterPlayerEmailStateImpl value,
          $Res Function(_$RegisterPlayerEmailStateImpl) then) =
      __$$RegisterPlayerEmailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? email});
}

/// @nodoc
class __$$RegisterPlayerEmailStateImplCopyWithImpl<$Res>
    extends _$RegisterPlayerEmailBaseStateCopyWithImpl<$Res,
        _$RegisterPlayerEmailStateImpl>
    implements _$$RegisterPlayerEmailStateImplCopyWith<$Res> {
  __$$RegisterPlayerEmailStateImplCopyWithImpl(
      _$RegisterPlayerEmailStateImpl _value,
      $Res Function(_$RegisterPlayerEmailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
  }) {
    return _then(_$RegisterPlayerEmailStateImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RegisterPlayerEmailStateImpl implements RegisterPlayerEmailState {
  const _$RegisterPlayerEmailStateImpl({required this.email});

  @override
  final String? email;

  @override
  String toString() {
    return 'RegisterPlayerEmailBaseState.state(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterPlayerEmailStateImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterPlayerEmailStateImplCopyWith<_$RegisterPlayerEmailStateImpl>
      get copyWith => __$$RegisterPlayerEmailStateImplCopyWithImpl<
          _$RegisterPlayerEmailStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? email) state,
  }) {
    return state(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? email)? state,
  }) {
    return state?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? email)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterPlayerEmailState value) state,
  }) {
    return state(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterPlayerEmailState value)? state,
  }) {
    return state?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterPlayerEmailState value)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(this);
    }
    return orElse();
  }
}

abstract class RegisterPlayerEmailState
    implements RegisterPlayerEmailBaseState {
  const factory RegisterPlayerEmailState({required final String? email}) =
      _$RegisterPlayerEmailStateImpl;

  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$RegisterPlayerEmailStateImplCopyWith<_$RegisterPlayerEmailStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
