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

class _CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late CameraManager _cameraManager;
  List<XFile> capturedImages = [];
  bool showGuidelines = true;
  late AnimationController _flashButtonController;
  late Animation<double> _flashButtonAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraManager = CameraManager();
    _cameraManager.initialize(widget.camera);
    
    _flashButtonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _flashButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _flashButtonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraManager.dispose();
    _flashButtonController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _cameraManager.controller;

    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _cameraManager.initialize(widget.camera);
    }
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

      if (capturedImages.length == 2) {
        _flashButtonController.repeat(reverse: true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Use flash for varied lighting'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      if (capturedImages.length == 5) {
        _navigateToSummaryScreen();
      }
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
    if (_flashButtonController.isAnimating) {
      _flashButtonController.stop();
    }
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
                  ScaleTransition(
                    scale: _flashButtonAnimation,
                    child: FloatingActionButton(
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
              onRemove: _removeImage,
            ),
        ],
      ),
    );
  }
}
