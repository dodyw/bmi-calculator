import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bmi_model.dart';
import '../utils/app_theme.dart';

class BMIGauge extends StatelessWidget {
  final BMIModel bmiModel;

  const BMIGauge({Key? key, required this.bmiModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: 180,
              sections: _buildGaugeSections(),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bmiModel.bmiValue.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: bmiModel.categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bmiModel.categoryName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: bmiModel.categoryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildGaugeSections() {
    // Define the gauge sections based on BMI categories
    final sections = <PieChartSectionData>[];

    // Underweight: < 18.5
    sections.add(
      PieChartSectionData(
        color: AppTheme.underweightColor,
        value: 18.5,
        title: '',
        radius: 20,
        showTitle: false,
      ),
    );

    // Normal: 18.5 - 24.9
    sections.add(
      PieChartSectionData(
        color: AppTheme.normalColor,
        value: 6.5, // 24.9 - 18.5 = 6.4
        title: '',
        radius: 20,
        showTitle: false,
      ),
    );

    // Overweight: 25 - 29.9
    sections.add(
      PieChartSectionData(
        color: AppTheme.warningColor,
        value: 5, // 29.9 - 25 = 4.9
        title: '',
        radius: 20,
        showTitle: false,
      ),
    );

    // Obese: >= 30
    sections.add(
      PieChartSectionData(
        color: AppTheme.errorColor,
        value: 20, // Just to complete the gauge
        title: '',
        radius: 20,
        showTitle: false,
      ),
    );

    return sections;
  }
}
