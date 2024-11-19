import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<dynamic> levels;

  const ResultScreen({super.key, required this.levels});

  double _calculateMean() {
    if (levels.isEmpty) return 0;
    return levels.reduce((a, b) => a + b) / levels.length;
  }

  String _getHealthStatus(double mean) {
    if (mean < 0.3) return 'Low Risk';
    if (mean < 0.7) return 'Moderate Risk';
    return 'High Risk';
  }

  Color _getStatusColor(double mean) {
    if (mean < 0.3) return Colors.green;
    if (mean < 0.7) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final mean = _calculateMean();
    final status = _getHealthStatus(mean);
    final statusColor = _getStatusColor(mean);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Average Biomarker Level: ${(mean * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Detailed Biomarker Levels',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 1,
                            barGroups: List.generate(
                              levels.length,
                              (index) => BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: levels[index],
                                    color: Colors.blue.withOpacity(0.8),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'B${value.toInt() + 1}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${(value * 100).toInt()}%',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: const FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              horizontalInterval: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
