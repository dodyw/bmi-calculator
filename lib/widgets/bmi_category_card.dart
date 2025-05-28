import 'package:flutter/material.dart';
import '../models/bmi_model.dart';

class BMICategoryCard extends StatelessWidget {
  final BMIModel bmiModel;

  const BMICategoryCard({Key? key, required this.bmiModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(),
                  color: bmiModel.categoryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'BMI Category: ${bmiModel.categoryName}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Health Recommendations:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              bmiModel.healthRecommendation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildBMIRangeInfo(context),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (bmiModel.category) {
      case BMICategory.underweight:
        return Icons.arrow_downward;
      case BMICategory.normal:
        return Icons.check_circle;
      case BMICategory.overweight:
        return Icons.warning;
      case BMICategory.obeseClass1:
      case BMICategory.obeseClass2:
      case BMICategory.obeseClass3:
        return Icons.priority_high;
    }
  }

  Widget _buildBMIRangeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BMI Categories:', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        _buildRangeRow(
          context,
          'Underweight',
          '< 18.5',
          bmiModel.category == BMICategory.underweight,
        ),
        _buildRangeRow(
          context,
          'Normal',
          '18.5 - 24.9',
          bmiModel.category == BMICategory.normal,
        ),
        _buildRangeRow(
          context,
          'Overweight',
          '25.0 - 29.9',
          bmiModel.category == BMICategory.overweight,
        ),
        _buildRangeRow(
          context,
          'Obese (Class I)',
          '30.0 - 34.9',
          bmiModel.category == BMICategory.obeseClass1,
        ),
        _buildRangeRow(
          context,
          'Obese (Class II)',
          '35.0 - 39.9',
          bmiModel.category == BMICategory.obeseClass2,
        ),
        _buildRangeRow(
          context,
          'Obese (Class III)',
          '≥ 40.0',
          bmiModel.category == BMICategory.obeseClass3,
        ),
      ],
    );
  }

  Widget _buildRangeRow(
    BuildContext context,
    String category,
    String range,
    bool isCurrentCategory,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (isCurrentCategory)
            const Icon(Icons.arrow_right, size: 16)
          else
            const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight:
                    isCurrentCategory ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              range,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight:
                    isCurrentCategory ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
