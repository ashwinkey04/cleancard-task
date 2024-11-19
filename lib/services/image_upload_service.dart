import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImageUploadService {
  final String _baseUrl = 'http://10.2.2.2:45457';

  Future<Map<String, dynamic>> uploadImages(List<XFile> images) async {
    final uri = Uri.parse(_baseUrl);
    final request = http.MultipartRequest('POST', uri);

    for (var i = 0; i < images.length; i++) {
      final file = await http.MultipartFile.fromPath(
        'image$i',
        images[i].path,
      );
      request.files.add(file);
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonData = json.decode(responseData);

    if (response.statusCode == 200) {
      return jsonData;
    } else {
      if (kDebugMode) {
        return {
          'messge': 'Simulated success on debug environment',
          'levels': [
            0.2547040111978315,
            0.20422688294300503,
            0.28208205599386293,
            0.21300636818935312,
            0.5296302806887846,
            0.5853518665734101,
            0.8500778099638591,
            0.6199193558702057
          ]
        };
      }
      throw Exception('Failed to upload images');
    }
  }
}
