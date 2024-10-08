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
  int get currentRound => throw _privateConstructorUsedError;
  GameState get gameState => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  HandGesture? get currentHandValue => throw _privateConstructorUsedError;
  HandGesture? get userGesture => throw _privateConstructorUsedError;
  int? get currentHandValueIndex => throw _privateConstructorUsedError;
  List<HandGesture>? get currentSequence => throw _privateConstructorUsedError;
  bool? get showDebug => throw _privateConstructorUsedError;
  List<
      ({
        ({
          double confidence,
          double h,
          double w,
          double x,
          double y
        }) boundingBox,
        HandGesture gesture,
        double gestureConfidence,
        ({double x, double y}) gesturePosition
      })>? get handSequenceHistory => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int currentPoints,
            int currentRound,
            GameState gameState,
            String? error,
            HandGesture? currentHandValue,
            HandGesture? userGesture,
            int? currentHandValueIndex,
            List<HandGesture>? currentSequence,
            bool? showDebug,
            List<
                    ({
                      ({
                        double confidence,
                        double h,
                        double w,
                        double x,
                        double y
                      }) boundingBox,
                      HandGesture gesture,
                      double gestureConfidence,
                      ({double x, double y}) gesturePosition
                    })>?
                handSequenceHistory)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int currentPoints,
            int currentRound,
            GameState gameState,
            String? error,
            HandGesture? currentHandValue,
            HandGesture? userGesture,
            int? currentHandValueIndex,
            List<HandGesture>? currentSequence,
            bool? showDebug,
            List<
                    ({
                      ({
                        double confidence,
                        double h,
                        double w,
                        double x,
                        double y
                      }) boundingBox,
                      HandGesture gesture,
                      double gestureConfidence,
                      ({double x, double y}) gesturePosition
                    })>?
                handSequenceHistory)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int currentPoints,
            int currentRound,
            GameState gameState,
            String? error,
            HandGesture? currentHandValue,
            HandGesture? userGesture,
            int? currentHandValueIndex,
            List<HandGesture>? currentSequence,
            bool? showDebug,
            List<
                    ({
                      ({
                        double confidence,
                        double h,
                        double w,
                        double x,
                        double y
                      }) boundingBox,
                      HandGesture gesture,
                      double gestureConfidence,
                      ({double x, double y}) gesturePosition
                    })>?
                handSequenceHistory)?
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
      int currentRound,
      GameState gameState,
      String? error,
      HandGesture? currentHandValue,
      HandGesture? userGesture,
      int? currentHandValueIndex,
      List<HandGesture>? currentSequence,
      bool? showDebug,
      List<
              ({
                ({
                  double confidence,
                  double h,
                  double w,
                  double x,
                  double y
                }) boundingBox,
                HandGesture gesture,
                double gestureConfidence,
                ({double x, double y}) gesturePosition
              })>?
          handSequenceHistory});
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
    Object? currentRound = null,
    Object? gameState = null,
    Object? error = freezed,
    Object? currentHandValue = freezed,
    Object? userGesture = freezed,
    Object? currentHandValueIndex = freezed,
    Object? currentSequence = freezed,
    Object? showDebug = freezed,
    Object? handSequenceHistory = freezed,
  }) {
    return _then(_value.copyWith(
      currentPoints: null == currentPoints
          ? _value.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      gameState: null == gameState
          ? _value.gameState
          : gameState // ignore: cast_nullable_to_non_nullable
              as GameState,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentHandValue: freezed == currentHandValue
          ? _value.currentHandValue
          : currentHandValue // ignore: cast_nullable_to_non_nullable
              as HandGesture?,
      userGesture: freezed == userGesture
          ? _value.userGesture
          : userGesture // ignore: cast_nullable_to_non_nullable
              as HandGesture?,
      currentHandValueIndex: freezed == currentHandValueIndex
          ? _value.currentHandValueIndex
          : currentHandValueIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSequence: freezed == currentSequence
          ? _value.currentSequence
          : currentSequence // ignore: cast_nullable_to_non_nullable
              as List<HandGesture>?,
      showDebug: freezed == showDebug
          ? _value.showDebug
          : showDebug // ignore: cast_nullable_to_non_nullable
              as bool?,
      handSequenceHistory: freezed == handSequenceHistory
          ? _value.handSequenceHistory
          : handSequenceHistory // ignore: cast_nullable_to_non_nullable
              as List<
                  ({
                    ({
                      double confidence,
                      double h,
                      double w,
                      double x,
                      double y
                    }) boundingBox,
                    HandGesture gesture,
                    double gestureConfidence,
                    ({double x, double y}) gesturePosition
                  })>?,
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
      int currentRound,
      GameState gameState,
      String? error,
      HandGesture? currentHandValue,
      HandGesture? userGesture,
      int? currentHandValueIndex,
      List<HandGesture>? currentSequence,
      bool? showDebug,
      List<
              ({
                ({
                  double confidence,
                  double h,
                  double w,
                  double x,
                  double y
                }) boundingBox,
                HandGesture gesture,
                double gestureConfidence,
                ({double x, double y}) gesturePosition
              })>?
          handSequenceHistory});
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
    Object? currentRound = null,
    Object? gameState = null,
    Object? error = freezed,
    Object? currentHandValue = freezed,
    Object? userGesture = freezed,
    Object? currentHandValueIndex = freezed,
    Object? currentSequence = freezed,
    Object? showDebug = freezed,
    Object? handSequenceHistory = freezed,
  }) {
    return _then(_$InitialImpl(
      currentPoints: null == currentPoints
          ? _value.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      gameState: null == gameState
          ? _value.gameState
          : gameState // ignore: cast_nullable_to_non_nullable
              as GameState,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentHandValue: freezed == currentHandValue
          ? _value.currentHandValue
          : currentHandValue // ignore: cast_nullable_to_non_nullable
              as HandGesture?,
      userGesture: freezed == userGesture
          ? _value.userGesture
          : userGesture // ignore: cast_nullable_to_non_nullable
              as HandGesture?,
      currentHandValueIndex: freezed == currentHandValueIndex
          ? _value.currentHandValueIndex
          : currentHandValueIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSequence: freezed == currentSequence
          ? _value._currentSequence
          : currentSequence // ignore: cast_nullable_to_non_nullable
              as List<HandGesture>?,
      showDebug: freezed == showDebug
          ? _value.showDebug
          : showDebug // ignore: cast_nullable_to_non_nullable
              as bool?,
      handSequenceHistory: freezed == handSequenceHistory
          ? _value._handSequenceHistory
          : handSequenceHistory // ignore: cast_nullable_to_non_nullable
              as List<
                  ({
                    ({
                      double confidence,
                      double h,
                      double w,
                      double x,
                      double y
                    }) boundingBox,
                    HandGesture gesture,
                    double gestureConfidence,
                    ({double x, double y}) gesturePosition
                  })>?,
    ));
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl(
      {required this.currentPoints,
      required this.currentRound,
      required this.gameState,
      this.error,
      this.currentHandValue,
      this.userGesture,
      this.currentHandValueIndex,
      final List<HandGesture>? currentSequence,
      this.showDebug,
      final List<
              ({
                ({
                  double confidence,
                  double h,
                  double w,
                  double x,
                  double y
                }) boundingBox,
                HandGesture gesture,
                double gestureConfidence,
                ({double x, double y}) gesturePosition
              })>?
          handSequenceHistory})
      : _currentSequence = currentSequence,
        _handSequenceHistory = handSequenceHistory;

  @override
  final int currentPoints;
  @override
  final int currentRound;
  @override
  final GameState gameState;
  @override
  final String? error;
  @override
  final HandGesture? currentHandValue;
  @override
  final HandGesture? userGesture;
  @override
  final int? currentHandValueIndex;
  final List<HandGesture>? _currentSequence;
  @override
  List<HandGesture>? get currentSequence {
    final value = _currentSequence;
    if (value == null) return null;
    if (_currentSequence is EqualUnmodifiableListView) return _currentSequence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? showDebug;
  final List<
      ({
        ({
          double confidence,
          double h,
          double w,
          double x,
          double y
        }) boundingBox,
        HandGesture gesture,
        double gestureConfidence,
        ({double x, double y}) gesturePosition
      })>? _handSequenceHistory;
  @override
  List<
      ({
        ({
          double confidence,
          double h,
          double w,
          double x,
          double y
        }) boundingBox,
        HandGesture gesture,
        double gestureConfidence,
        ({double x, double y}) gesturePosition
      })>? get handSequenceHistory {
    final value = _handSequenceHistory;
    if (value == null) return null;
    if (_handSequenceHistory is EqualUnmodifiableListView)
      return _handSequenceHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GameScreenState.initial(currentPoints: $currentPoints, currentRound: $currentRound, gameState: $gameState, error: $error, currentHandValue: $currentHandValue, userGesture: $userGesture, currentHandValueIndex: $currentHandValueIndex, currentSequence: $currentSequence, showDebug: $showDebug, handSequenceHistory: $handSequenceHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentHandValue, currentHandValue) ||
                other.currentHandValue == currentHandValue) &&
            (identical(other.userGesture, userGesture) ||
                other.userGesture == userGesture) &&
            (identical(other.currentHandValueIndex, currentHandValueIndex) ||
                other.currentHandValueIndex == currentHandValueIndex) &&
            const DeepCollectionEquality()
                .equals(other._currentSequence, _currentSequence) &&
            (identical(other.showDebug, showDebug) ||
                other.showDebug == showDebug) &&
            const DeepCollectionEquality()
                .equals(other._handSequenceHistory, _handSequenceHistory));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentPoints,
      currentRound,
      gameState,
      error,
      currentHandValue,
      userGesture,
      currentHandValueIndex,
      const DeepCollectionEquality().hash(_currentSequence),
      showDebug,
      const DeepCollectionEquality().hash(_handSequenceHistory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int currentPoints,
            int currentRound,
            GameState gameState,
            String? error,
            HandGesture? currentHandValue,
            HandGesture? userGesture,
            int? currentHandValueIndex,
            List<HandGesture>? currentSequence,
            bool? showDebug,
            List<
                    ({
                      ({
                        double confidence,
                        double h,
                        double w,
                        double x,
                        double y
                      }) boundingBox,
                      HandGesture gesture,
                      double gestureConfidence,
                      ({double x, double y}) gesturePosition
                    })>?
                handSequenceHistory)
        initial,
  }) {
    return initial(
        currentPoints,
        currentRound,
        gameState,
        error,
        currentHandValue,
        userGesture,
        currentHandValueIndex,
        currentSequence,
        showDebug,
        handSequenceHistory);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int currentPoints,
            int currentRound,
            GameState gameState,
            String? error,
            HandGesture? currentHandValue,
            HandGesture? userGesture,
            int? currentHandValueIndex,
            List<HandGesture>? currentSequence,
            bool? showDebug,
            List<
                    ({
                      ({
                        double confidence,
                        double h,
                        double w,
                        double x,
                        double y
                      }) boundingBox,
                      HandGesture gesture,
                      double gestureConfidence,
                      ({double x, double y}) gesturePosition
                    })>?
                handSequenceHistory)?
        initial,
  }) {
    return initial?.call(
        currentPoints,
        currentRound,
        gameState,
        error,
        currentHandValue,
        userGesture,
        currentHandValueIndex,
        currentSequence,
        showDebug,
        handSequenceHistory);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int currentPoints,
            int currentRound,
            GameState gameState,
            String? error,
            HandGesture? currentHandValue,
            HandGesture? userGesture,
            int? currentHandValueIndex,
            List<HandGesture>? currentSequence,
            bool? showDebug,
            List<
                    ({
                      ({
                        double confidence,
                        double h,
                        double w,
                        double x,
                        double y
                      }) boundingBox,
                      HandGesture gesture,
                      double gestureConfidence,
                      ({double x, double y}) gesturePosition
                    })>?
                handSequenceHistory)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
          currentPoints,
          currentRound,
          gameState,
          error,
          currentHandValue,
          userGesture,
          currentHandValueIndex,
          currentSequence,
          showDebug,
          handSequenceHistory);
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
      required final int currentRound,
      required final GameState gameState,
      final String? error,
      final HandGesture? currentHandValue,
      final HandGesture? userGesture,
      final int? currentHandValueIndex,
      final List<HandGesture>? currentSequence,
      final bool? showDebug,
      final List<
              ({
                ({
                  double confidence,
                  double h,
                  double w,
                  double x,
                  double y
                }) boundingBox,
                HandGesture gesture,
                double gestureConfidence,
                ({double x, double y}) gesturePosition
              })>?
          handSequenceHistory}) = _$InitialImpl;

  @override
  int get currentPoints;
  @override
  int get currentRound;
  @override
  GameState get gameState;
  @override
  String? get error;
  @override
  HandGesture? get currentHandValue;
  @override
  HandGesture? get userGesture;
  @override
  int? get currentHandValueIndex;
  @override
  List<HandGesture>? get currentSequence;
  @override
  bool? get showDebug;
  @override
  List<
      ({
        ({
          double confidence,
          double h,
          double w,
          double x,
          double y
        }) boundingBox,
        HandGesture gesture,
        double gestureConfidence,
        ({double x, double y}) gesturePosition
      })>? get handSequenceHistory;
  @override
  @JsonKey(ignore: true)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
