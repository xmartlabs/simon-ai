// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_hand_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CameraHandState {
  Stream<dynamic>? get gestureStream => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Stream<dynamic>? gestureStream) state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Stream<dynamic>? gestureStream)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Stream<dynamic>? gestureStream)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CameraHandState value) state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CameraHandState value)? state,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CameraHandState value)? state,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CameraHandStateCopyWith<CameraHandState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraHandStateCopyWith<$Res> {
  factory $CameraHandStateCopyWith(
          CameraHandState value, $Res Function(CameraHandState) then) =
      _$CameraHandStateCopyWithImpl<$Res, CameraHandState>;
  @useResult
  $Res call({Stream<dynamic>? gestureStream});
}

/// @nodoc
class _$CameraHandStateCopyWithImpl<$Res, $Val extends CameraHandState>
    implements $CameraHandStateCopyWith<$Res> {
  _$CameraHandStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gestureStream = freezed,
  }) {
    return _then(_value.copyWith(
      gestureStream: freezed == gestureStream
          ? _value.gestureStream
          : gestureStream // ignore: cast_nullable_to_non_nullable
              as Stream<dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CameraHandStateImplCopyWith<$Res>
    implements $CameraHandStateCopyWith<$Res> {
  factory _$$CameraHandStateImplCopyWith(_$CameraHandStateImpl value,
          $Res Function(_$CameraHandStateImpl) then) =
      __$$CameraHandStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Stream<dynamic>? gestureStream});
}

/// @nodoc
class __$$CameraHandStateImplCopyWithImpl<$Res>
    extends _$CameraHandStateCopyWithImpl<$Res, _$CameraHandStateImpl>
    implements _$$CameraHandStateImplCopyWith<$Res> {
  __$$CameraHandStateImplCopyWithImpl(
      _$CameraHandStateImpl _value, $Res Function(_$CameraHandStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gestureStream = freezed,
  }) {
    return _then(_$CameraHandStateImpl(
      gestureStream: freezed == gestureStream
          ? _value.gestureStream
          : gestureStream // ignore: cast_nullable_to_non_nullable
              as Stream<dynamic>?,
    ));
  }
}

/// @nodoc

class _$CameraHandStateImpl implements _CameraHandState {
  const _$CameraHandStateImpl({this.gestureStream = null});

  @override
  @JsonKey()
  final Stream<dynamic>? gestureStream;

  @override
  String toString() {
    return 'CameraHandState.state(gestureStream: $gestureStream)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraHandStateImpl &&
            (identical(other.gestureStream, gestureStream) ||
                other.gestureStream == gestureStream));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gestureStream);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraHandStateImplCopyWith<_$CameraHandStateImpl> get copyWith =>
      __$$CameraHandStateImplCopyWithImpl<_$CameraHandStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Stream<dynamic>? gestureStream) state,
  }) {
    return state(gestureStream);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Stream<dynamic>? gestureStream)? state,
  }) {
    return state?.call(gestureStream);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Stream<dynamic>? gestureStream)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(gestureStream);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CameraHandState value) state,
  }) {
    return state(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CameraHandState value)? state,
  }) {
    return state?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CameraHandState value)? state,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(this);
    }
    return orElse();
  }
}

abstract class _CameraHandState implements CameraHandState {
  const factory _CameraHandState({final Stream<dynamic>? gestureStream}) =
      _$CameraHandStateImpl;

  @override
  Stream<dynamic>? get gestureStream;
  @override
  @JsonKey(ignore: true)
  _$$CameraHandStateImplCopyWith<_$CameraHandStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
