import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bmi_model.dart';
import '../utils/app_theme.dart';

class BMIHistoryChart extends StatelessWidget {
  final List<BMIModel> bmiHistory;

  const BMIHistoryChart({Key? key, required this.bmiHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bmiHistory.isEmpty || bmiHistory.length < 2) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Not enough data to display chart.\nCalculate your BMI at least twice to see your progress.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 &&
                        value.toInt() < bmiHistory.length) {
                      final date = bmiHistory[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${date.day}/${date.month}',
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _createSpots(),
                isCurved: true,
                color: AppTheme.primaryColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
            ],
            minY: _getMinY(),
            maxY: _getMaxY(),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppTheme.primaryDarkColor,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    final index = touchedSpot.x.toInt();
                    if (index >= 0 && index < bmiHistory.length) {
                      final bmi = bmiHistory[index];
                      return LineTooltipItem(
                        '${bmi.bmiValue.toStringAsFixed(1)} BMI\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: bmi.categoryName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }
                    return null;
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    final spots = <FlSpot>[];
    for (int i = 0; i < bmiHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), bmiHistory[i].bmiValue));
    }
    return spots;
  }

  double _getMinY() {
    if (bmiHistory.isEmpty) return 0;
    double minBmi = bmiHistory.first.bmiValue;
    for (final bmi in bmiHistory) {
      if (bmi.bmiValue < minBmi) {
        minBmi = bmi.bmiValue;
      }
    }
    return (minBmi - 2).clamp(0, double.infinity);
  }

  double _getMaxY() {
    if (bmiHistory.isEmpty) return 40;
    double maxBmi = bmiHistory.first.bmiValue;
    for (final bmi in bmiHistory) {
      if (bmi.bmiValue > maxBmi) {
        maxBmi = bmi.bmiValue;
      }
    }
    return maxBmi + 2;
  }
}
