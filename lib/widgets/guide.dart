import 'package:flutter/material.dart';

Widget buildGuidelines() {
  return const Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GuidelineCard(
            icon: Icons.wb_sunny_outlined,
            title: 'Lighting',
            subtitle: 'Ensure even illumination',
            color: Color(0xFFE65100),
          ),
          GuidelineCard(
            icon: Icons.center_focus_strong,
            title: 'Position',
            subtitle: 'Center card in frame',
            color: Color(0xFF1565C0),
          ),
          GuidelineCard(
            icon: Icons.pan_tool_outlined,
            title: 'Stability',
            subtitle: 'Keep device steady',
            color: Color(0xFF2E7D32),
          ),
        ],
      ),
      SizedBox(height: 16),
    ],
  );
}

class GuidelineCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const GuidelineCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
