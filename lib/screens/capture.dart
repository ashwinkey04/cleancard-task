import 'package:camera/camera.dart';
import 'package:cleancard_task/controllers/camera_controller.dart';
import 'package:cleancard_task/screens/summary.dart';
import 'package:cleancard_task/widgets/camera_preview_widget.dart';
import 'package:cleancard_task/widgets/captured_images_list.dart';
import 'package:cleancard_task/widgets/guide.dart';
import 'package:flutter/material.dart';

class CaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  const CaptureScreen({super.key, required this.camera});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late CameraManager _cameraManager;
  List<XFile> capturedImages = [];
  bool showGuidelines = true;

  @override
  void initState() {
    super.initState();
    _cameraManager = CameraManager();
    _cameraManager.initialize(widget.camera);
  }

  @override
  void dispose() {
    _cameraManager.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    await _handleImageCapture(() async {
      final image = await _cameraManager.controller.takePicture();
      setState(() {
        capturedImages.add(image);
        if (capturedImages.length == 1) {
          showGuidelines = false;
        }
      });

      if (capturedImages.length == 5) {
        _navigateToSummaryScreen();
      }
    });
  }

  void _retakeImage(int index) async {
    await _handleImageCapture(() async {
      final image = await _cameraManager.controller.takePicture();
      setState(() {
        capturedImages[index] = image;
      });
    });
  }

  Future<void> _handleImageCapture(
      Future<void> Function() captureAction) async {
    try {
      await _cameraManager.initializeControllerFuture;
      await captureAction();
    } catch (e) {
      print(e);
    }
  }

  void _navigateToSummaryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(images: capturedImages),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      capturedImages.removeAt(index);
      if (capturedImages.isEmpty) {
        showGuidelines = true;
      }
    });
  }

  void _toggleFlashMode() {
    setState(() {
      _cameraManager.toggleFlashMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: _buildAppBar(theme),
      body: Column(
        children: [
          CameraPreviewWidget(
            controller: _cameraManager.controller,
            initializeControllerFuture:
                _cameraManager.initializeControllerFuture,
          ),
          _buildBottomContainer(theme),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      leading: BackButton(
        color: theme.colorScheme.onPrimary,
      ),
      elevation: 0,
      title: Text(
        'Image ${capturedImages.length + 1} of 5',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container _buildBottomContainer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: _toggleFlashMode,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      _cameraManager.currentFlashMode == FlashMode.off
                          ? Icons.flash_off
                          : _cameraManager.currentFlashMode == FlashMode.always
                              ? Icons.flash_on
                              : Icons.flash_auto,
                      size: 24,
                    ),
                  ),
                ],
              ),
              Center(
                child: FloatingActionButton.large(
                  onPressed: _captureImage,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.camera_alt_rounded, size: 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (showGuidelines)
            buildGuidelines()
          else
            CapturedImagesList(
              capturedImages: capturedImages,
              onRetake: _retakeImage,
              onRemove: _removeImage,
            ),
        ],
      ),
    );
  }
}
