import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraLiveView extends StatefulWidget {
  const CameraLiveView({
    super.key,
  });

  @override
  State<CameraLiveView> createState() => CameraLiveViewState();
}

class CameraLiveViewState extends State<CameraLiveView> {
  CameraController? _cameraController;

  @override
  void initState() {
    initCameraController();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  Future<void> initCameraController() async {
    final list = await availableCameras();
    _cameraController = CameraController(
      list.firstWhere(
        (elem) => elem.lensDirection == CameraLensDirection.front,
      ),
      ResolutionPreset.max,
    );
    await _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraController = _cameraController;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            //TODO: Handle access errors here.
            break;
          default:
            //TODO: Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }
    return Transform.scale(
      scaleX: .92,
      scaleY: .85,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: CameraPreview(
          _cameraController!,
        ),
      ),
    );
  }
}
