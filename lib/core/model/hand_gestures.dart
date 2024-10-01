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

List<HandGesture> get playableGestures => [
      HandGesture.closed,
      HandGesture.open,
      HandGesture.pointingUp,
      HandGesture.thumbsUp,
      HandGesture.victory,
      HandGesture.love,
    ];
