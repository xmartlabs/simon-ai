// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_area_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminAreaState {
  String? get currentUserEmail => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? currentUserEmail, String? email,
            String? password, String? error)
        state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? currentUserEmail, String? email, String? password,
            String? error)?
        state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? currentUserEmail, String? email, String? password,
            String? error)?
        state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AdminAreaState value) state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AdminAreaState value)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminAreaState value)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminAreaStateCopyWith<AdminAreaState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminAreaStateCopyWith<$Res> {
  factory $AdminAreaStateCopyWith(
          AdminAreaState value, $Res Function(AdminAreaState) then) =
      _$AdminAreaStateCopyWithImpl<$Res, AdminAreaState>;
  @useResult
  $Res call(
      {String? currentUserEmail,
      String? email,
      String? password,
      String? error});
}

/// @nodoc
class _$AdminAreaStateCopyWithImpl<$Res, $Val extends AdminAreaState>
    implements $AdminAreaStateCopyWith<$Res> {
  _$AdminAreaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUserEmail = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      currentUserEmail: freezed == currentUserEmail
          ? _value.currentUserEmail
          : currentUserEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminAreaStateImplCopyWith<$Res>
    implements $AdminAreaStateCopyWith<$Res> {
  factory _$$AdminAreaStateImplCopyWith(_$AdminAreaStateImpl value,
          $Res Function(_$AdminAreaStateImpl) then) =
      __$$AdminAreaStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? currentUserEmail,
      String? email,
      String? password,
      String? error});
}

/// @nodoc
class __$$AdminAreaStateImplCopyWithImpl<$Res>
    extends _$AdminAreaStateCopyWithImpl<$Res, _$AdminAreaStateImpl>
    implements _$$AdminAreaStateImplCopyWith<$Res> {
  __$$AdminAreaStateImplCopyWithImpl(
      _$AdminAreaStateImpl _value, $Res Function(_$AdminAreaStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUserEmail = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? error = freezed,
  }) {
    return _then(_$AdminAreaStateImpl(
      currentUserEmail: freezed == currentUserEmail
          ? _value.currentUserEmail
          : currentUserEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AdminAreaStateImpl implements _AdminAreaState {
  const _$AdminAreaStateImpl(
      {this.currentUserEmail, this.email, this.password, this.error});

  @override
  final String? currentUserEmail;
  @override
  final String? email;
  @override
  final String? password;
  @override
  final String? error;

  @override
  String toString() {
    return 'AdminAreaState.state(currentUserEmail: $currentUserEmail, email: $email, password: $password, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminAreaStateImpl &&
            (identical(other.currentUserEmail, currentUserEmail) ||
                other.currentUserEmail == currentUserEmail) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentUserEmail, email, password, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminAreaStateImplCopyWith<_$AdminAreaStateImpl> get copyWith =>
      __$$AdminAreaStateImplCopyWithImpl<_$AdminAreaStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? currentUserEmail, String? email,
            String? password, String? error)
        state,
  }) {
    return state(currentUserEmail, email, password, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? currentUserEmail, String? email, String? password,
            String? error)?
        state,
  }) {
    return state?.call(currentUserEmail, email, password, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? currentUserEmail, String? email, String? password,
            String? error)?
        state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(currentUserEmail, email, password, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AdminAreaState value) state,
  }) {
    return state(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AdminAreaState value)? state,
  }) {
    return state?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminAreaState value)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(this);
    }
    return orElse();
  }
}

abstract class _AdminAreaState implements AdminAreaState {
  const factory _AdminAreaState(
      {final String? currentUserEmail,
      final String? email,
      final String? password,
      final String? error}) = _$AdminAreaStateImpl;

  @override
  String? get currentUserEmail;
  @override
  String? get email;
  @override
  String? get password;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$AdminAreaStateImplCopyWith<_$AdminAreaStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
