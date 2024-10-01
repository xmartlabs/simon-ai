abstract interface class PermissionHandlerInterface {
  Future<bool?> requestCameraPermission();

  Future<bool> hasCameraPermisssion();

  Future<void> openAppSettings();
}
