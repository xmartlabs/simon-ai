import 'package:design_system/gen/assets.gen.dart';

enum HandGesture {
  unrecognized,
  closed,
  open,
  pointingUp,
  thumbsDown,
  thumbsUp,
  victory,
  love
}

extension HandGesturesExtension on HandGesture {
  String get emoji {
    switch (this) {
      case HandGesture.closed:
        return '✊';
      case HandGesture.open:
        return '✋';
      case HandGesture.pointingUp:
        return '☝️';
      case HandGesture.thumbsDown:
        return '👎';
      case HandGesture.thumbsUp:
        return '👍';
      case HandGesture.victory:
        return '✌️';
      case HandGesture.love:
        return '🤟';
      case HandGesture.unrecognized:
        return '❓';
    }
  }
}

extension HandGesturesExtensionHallowween on HandGesture {
  AssetGenImage? get halloweenEmoji {
    switch (this) {
      case HandGesture.closed:
        return Assets.images.closed;
      case HandGesture.pointingUp:
        return Assets.images.pointingUp;
      case HandGesture.thumbsDown:
        return Assets.images.thumbsDown;
      case HandGesture.thumbsUp:
        return Assets.images.thumbsUp;
      case HandGesture.victory:
        return Assets.images.victory;
      case HandGesture.love:
        return Assets.images.love;
      case HandGesture.open:
      case HandGesture.unrecognized:
        return null;
    }
  }
}

List<HandGesture> get playableGestures => [
      HandGesture.closed,
      HandGesture.pointingUp,
      HandGesture.thumbsUp,
      HandGesture.victory,
      HandGesture.love,
    ];
