import 'package:camera/camera.dart';

class CameraManager {
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  FlashMode currentFlashMode = FlashMode.auto;

  Future<void> initialize(CameraDescription camera) async {
    controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    initializeControllerFuture = controller.initialize();
  }

  void toggleFlashMode() {
    if (currentFlashMode == FlashMode.off) {
      currentFlashMode = FlashMode.always;
    } else if (currentFlashMode == FlashMode.always) {
      currentFlashMode = FlashMode.auto;
    } else {
      currentFlashMode = FlashMode.off;
    }
    controller.setFlashMode(currentFlashMode);
  }

  void dispose() {
    controller.dispose();
  }
}
