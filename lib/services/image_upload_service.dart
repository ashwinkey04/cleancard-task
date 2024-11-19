import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImageUploadService {
  final String _baseUrl = 'https://cleancard-task.onrender.com/';

  Future<Map<String, dynamic>> analyzeImages(List<XFile> images) async {
    if (images.isEmpty) {
      throw Exception('No images to upload');
    }

    final uri = Uri.parse(_baseUrl);
    final file = await http.MultipartFile.fromPath(
      'file',
      images[0].path,
    );

    final request = http.Request('POST', uri)
      ..headers['Content-Type'] = 'application/octet-stream'
      ..bodyBytes = await file.finalize().toBytes();

    final response = await http.Response.fromStream(await request.send());
    final jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return jsonData;
    } else {
      if (kDebugMode) {
        return {
          'status': 'simulated success',
          'levels': [
            0.10782698102011974,
            0.6037071865526278,
            0.5490397665531002,
            0.5541802285132418,
            0.8701385240699487,
            0.7554621183675393,
            0.3983022762458544,
            0.9653827180074022
          ]
        };
      }
      throw Exception('Failed to upload images');
    }
  }
}
