import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simon_ai/core/interfaces/permission_handler_interface.dart';

class MobilePermissionHandlerService implements PermissionHandlerInterface {
  @override
  Future<bool> hasCameraPermisssion() => Permission.camera.status.isGranted;

  @override
  Future<void> openAppSettings() => AppSettings.openAppSettings();

  @override
  Future<bool?> requestCameraPermission() async {
    if (await hasCameraPermisssion()) return true;
    final hasNotRequestedPermissions = await hasNotRequestedCameraPermission();

    if (hasNotRequestedPermissions) {
      return Permission.camera.request().isGranted;
    } else {
      await AppSettings.openAppSettings();
      return hasCameraPermisssion();
    }
  }

  Future<bool> hasNotRequestedCameraPermission() async {
    final cameraPermission = await Permission.camera.status;
    return cameraPermission == PermissionStatus.denied;
  }
}
