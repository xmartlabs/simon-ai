typedef ModelMetadata = ({
  String path,
  int inputSize,
});

extension ModelMetadataExtension on List<ModelMetadata> {
  ModelMetadata get handDetector => first;
  ModelMetadata get handLandmarksDetector => this[1];
}
