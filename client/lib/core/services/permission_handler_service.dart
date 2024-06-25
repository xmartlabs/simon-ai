import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simon_ai/core/interfaces/permission_handler_interface.dart';

class PermissionHandlerService implements PermissionHandlerInterface {
  @override
  Future<bool> hasCameraPermisssion() => Permission.camera.status.isGranted;

  @override
  Future<void> openAppSettings() => AppSettings.openAppSettings();

  @override
  Future<bool?> requestCameraPermission() async {
    final hasNotRequestedPermissions = await hasNotRequestedCameraPermission();

    if (hasNotRequestedPermissions) {
      return Permission.contacts.request().isGranted;
    } else {
      await AppSettings.openAppSettings();
      return null;
    }
  }

  Future<bool> hasNotRequestedCameraPermission() async {
    final cameraPermission = await Permission.camera.status;
    return cameraPermission == PermissionStatus.denied;
  }
}
