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

List<HandGesture> get playableGestures => [
      HandGesture.closed,
      HandGesture.open,
      HandGesture.pointingUp,
      HandGesture.thumbsUp,
      HandGesture.victory,
      HandGesture.love,
    ];
