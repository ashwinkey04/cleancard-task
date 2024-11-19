import 'package:camera/camera.dart';
import 'package:cleancard_task/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  // Find the back camera
  final backCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.back,
    orElse: () =>
        cameras.first, // Fallback to first camera if back camera not found
  );

  runApp(MyApp(camera: backCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanCard Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F9FB),
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4C84DC),
          secondary: Color(0xFF588CE0),
          surface: Color(0xFFC2CCDB),
          background: Color(0xFFF6F9FB),
          onPrimary: Colors.white,
          onSecondary: Color(0xFF1C2C44),
          onSurface: Color(0xFF1C2C44),
          onBackground: Color(0xFF1C2C44),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF1C2C44)),
            bodyMedium: TextStyle(color: Color(0xFF919DB4)),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF4C84DC),
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4C84DC),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(),
          ),
        ),
        useMaterial3: true,
      ),
      home: HomePage(camera: camera),
    );
  }
}
