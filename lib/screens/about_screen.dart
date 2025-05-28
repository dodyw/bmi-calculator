import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About BMI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: 'What is BMI?',
              content:
                  'Body Mass Index (BMI) is a numerical value of your weight in relation to your height. It is a commonly used indicator to categorize individuals as underweight, normal weight, overweight, or obese.',
              icon: Icons.info_outline,
            ),
            _buildSection(
              context,
              title: 'How is BMI Calculated?',
              content:
                  'BMI is calculated by dividing your weight in kilograms by the square of your height in meters:\n\nBMI = weight(kg) / height²(m²)\n\nFor imperial units, the formula is:\nBMI = 703 × weight(lb) / height²(in²)',
              icon: Icons.calculate,
            ),
            _buildSection(
              context,
              title: 'BMI Categories',
              content:
                  'According to the World Health Organization (WHO), BMI categories are defined as:\n\n• Underweight: BMI < 18.5\n• Normal weight: 18.5 ≤ BMI < 25\n• Overweight: 25 ≤ BMI < 30\n• Obesity class I: 30 ≤ BMI < 35\n• Obesity class II: 35 ≤ BMI < 40\n• Obesity class III: BMI ≥ 40',
              icon: Icons.category,
            ),
            _buildSection(
              context,
              title: 'Limitations of BMI',
              content:
                  'While BMI is a useful tool for assessing weight status in the general population, it has several limitations:\n\n• It does not distinguish between fat, muscle, and bone mass\n• It may overestimate body fat in athletes and muscular individuals\n• It may underestimate body fat in older persons and those who have lost muscle mass\n• It does not account for body fat distribution\n• It may not be applicable to all ethnic groups',
              icon: Icons.warning,
            ),
            _buildSection(
              context,
              title: 'Medical Disclaimer',
              content:
                  'This BMI calculator is provided for informational purposes only and is not intended as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.',
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'BMI Calculator v1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
