import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CapturedImagesList extends StatelessWidget {
  final List<XFile> capturedImages;

  final Function(int) onRemove;

  const CapturedImagesList({
    super.key,
    required this.capturedImages,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          if (index < capturedImages.length) {
            return _buildCapturedImageCard(theme, index);
          } else {
            return _buildPlaceholderCard(digit: '${index + 1}');
          }
        },
      ),
    );
  }

  Widget _buildCapturedImageCard(ThemeData theme, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            _buildImagePreview(index, theme),
            _buildGradientBackground(),
            _buildImageActions(index, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard({String? digit}) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Text(digit ?? ''),
      ),
    );
  }

  Widget _buildImagePreview(int index, ThemeData theme) {
    return FutureBuilder<void>(
      future: capturedImages[index].readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data as Uint8List,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          );
        }
        return SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
      ),
    );
  }

  Positioned _buildImageActions(int index, ThemeData theme) {
    return Positioned(
      top: 4,
      right: 4,
      child: Row(
        children: [
          _buildIconButton(Icons.close, () => onRemove(index), theme),
        ],
      ),
    );
  }

  IconButton _buildIconButton(
      IconData icon, VoidCallback onPressed, ThemeData theme) {
    return IconButton(
      icon: Icon(
        icon,
        color: theme.colorScheme.onPrimary,
        size: 20,
      ),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
