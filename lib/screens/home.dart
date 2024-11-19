import 'package:camera/camera.dart';
import 'package:cleancard_task/screens/capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class HomePage extends StatelessWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OnBoardingSlider(
      background: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                children: [
                  Icon(Icons.camera_enhance,
                      size: 100, color: theme.primaryColor),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '5',
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny, size: 128, color: Colors.orange),
              SizedBox(width: 20),
              Icon(Icons.flash_on, size: 92, color: Colors.yellow),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Icon(Icons.crop_free, size: 64, color: theme.primaryColor),
                const Text('Frame'),
              ]),
              Column(children: [
                Icon(Icons.photo_camera, size: 64, color: theme.primaryColor),
                const Text('Capture'),
              ]),
              Column(children: [
                Icon(Icons.check_circle, size: 64, color: theme.primaryColor),
                const Text('Submit'),
              ]),
            ],
          ),
        ),
      ],
      headerBackgroundColor: Colors.white,
      finishButtonText: 'Start Capture',
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      skipTextButton: const Text('Skip'),
      centerBackground: true,
      totalPage: 3,
      speed: 1.8,
      pageBodies: [
        // First Page
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Capture 5 High-Quality Photos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'To ensure accurate results, we need to capture 5 images of the Cleancard under good lighting conditions.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Second Page
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Lighting Matters',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Make sure the device is visible, focused, and well-lit in each photo. Try both natural light and flash for best results.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Third Page
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Follow These Steps',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                '1. Position the Cleancard in the camera frame\n2. Ensure good lighting\n3. Hold your phone steady\n4. Capture five images\n5. Review and submit',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
      onFinish: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaptureScreen(camera: camera),
          ),
        );
      },
    );
  }
}
