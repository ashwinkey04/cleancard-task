import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cleancard_task/screens/results.dart';
import 'package:cleancard_task/services/image_upload_service.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  final List<XFile> images;

  const SummaryScreen({super.key, required this.images});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isUploading = false;

  Future<void> _uploadImages(BuildContext context) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final imageUploadService = ImageUploadService();
      final jsonData = await imageUploadService.analyzeImages(widget.images);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(levels: jsonData['levels']),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading images')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Images'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.file(
                  File(widget.images[index].path),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _uploadImages(context),
                    child: const Text('Upload Images'),
                  ),
          ),
        ],
      ),
    );
  }
}
