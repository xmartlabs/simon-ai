// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameScreenState {
  int get currentPoints => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get currentHandValue => throw _privateConstructorUsedError;
  List<String>? get handGestures => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentPoints, String? error,
            String? currentHandValue, List<String>? handGestures)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentPoints, String? error,
            String? currentHandValue, List<String>? handGestures)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentPoints, String? error, String? currentHandValue,
            List<String>? handGestures)?
        initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameScreenStateCopyWith<GameScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameScreenStateCopyWith<$Res> {
  factory $GameScreenStateCopyWith(
          GameScreenState value, $Res Function(GameScreenState) then) =
      _$GameScreenStateCopyWithImpl<$Res, GameScreenState>;
  @useResult
  $Res call(
      {int currentPoints,
      String? error,
      String? currentHandValue,
      List<String>? handGestures});
}

/// @nodoc
class _$GameScreenStateCopyWithImpl<$Res, $Val extends GameScreenState>
    implements $GameScreenStateCopyWith<$Res> {
  _$GameScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPoints = null,
    Object? error = freezed,
    Object? currentHandValue = freezed,
    Object? handGestures = freezed,
  }) {
    return _then(_value.copyWith(
      currentPoints: null == currentPoints
          ? _value.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentHandValue: freezed == currentHandValue
          ? _value.currentHandValue
          : currentHandValue // ignore: cast_nullable_to_non_nullable
              as String?,
      handGestures: freezed == handGestures
          ? _value.handGestures
          : handGestures // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $GameScreenStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentPoints,
      String? error,
      String? currentHandValue,
      List<String>? handGestures});
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$GameScreenStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPoints = null,
    Object? error = freezed,
    Object? currentHandValue = freezed,
    Object? handGestures = freezed,
  }) {
    return _then(_$InitialImpl(
      currentPoints: null == currentPoints
          ? _value.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentHandValue: freezed == currentHandValue
          ? _value.currentHandValue
          : currentHandValue // ignore: cast_nullable_to_non_nullable
              as String?,
      handGestures: freezed == handGestures
          ? _value._handGestures
          : handGestures // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl(
      {required this.currentPoints,
      this.error,
      this.currentHandValue,
      final List<String>? handGestures})
      : _handGestures = handGestures;

  @override
  final int currentPoints;
  @override
  final String? error;
  @override
  final String? currentHandValue;
  final List<String>? _handGestures;
  @override
  List<String>? get handGestures {
    final value = _handGestures;
    if (value == null) return null;
    if (_handGestures is EqualUnmodifiableListView) return _handGestures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GameScreenState.initial(currentPoints: $currentPoints, error: $error, currentHandValue: $currentHandValue, handGestures: $handGestures)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentHandValue, currentHandValue) ||
                other.currentHandValue == currentHandValue) &&
            const DeepCollectionEquality()
                .equals(other._handGestures, _handGestures));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPoints, error,
      currentHandValue, const DeepCollectionEquality().hash(_handGestures));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentPoints, String? error,
            String? currentHandValue, List<String>? handGestures)
        initial,
  }) {
    return initial(currentPoints, error, currentHandValue, handGestures);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentPoints, String? error,
            String? currentHandValue, List<String>? handGestures)?
        initial,
  }) {
    return initial?.call(currentPoints, error, currentHandValue, handGestures);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentPoints, String? error, String? currentHandValue,
            List<String>? handGestures)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(currentPoints, error, currentHandValue, handGestures);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements GameScreenState {
  const factory _Initial(
      {required final int currentPoints,
      final String? error,
      final String? currentHandValue,
      final List<String>? handGestures}) = _$InitialImpl;

  @override
  int get currentPoints;
  @override
  String? get error;
  @override
  String? get currentHandValue;
  @override
  List<String>? get handGestures;
  @override
  @JsonKey(ignore: true)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
