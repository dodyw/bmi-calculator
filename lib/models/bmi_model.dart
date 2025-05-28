import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum BMICategory {
  underweight,
  normal,
  overweight,
  obeseClass1,
  obeseClass2,
  obeseClass3,
}

class BMIModel {
  final double height; // in cm
  final double weight; // in kg
  final DateTime date;
  late final double bmiValue;
  late final BMICategory category;

  BMIModel({required this.height, required this.weight, DateTime? date})
    : date = date ?? DateTime.now() {
    bmiValue = calculateBMI();
    category = determineCategory();
  }

  // Calculate BMI using the formula: weight (kg) / (height (m))²
  double calculateBMI() {
    // Convert height from cm to m
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  // Determine BMI category based on WHO standards
  BMICategory determineCategory() {
    if (bmiValue < 18.5) {
      return BMICategory.underweight;
    } else if (bmiValue < 25) {
      return BMICategory.normal;
    } else if (bmiValue < 30) {
      return BMICategory.overweight;
    } else if (bmiValue < 35) {
      return BMICategory.obeseClass1;
    } else if (bmiValue < 40) {
      return BMICategory.obeseClass2;
    } else {
      return BMICategory.obeseClass3;
    }
  }

  // Get category name as a string
  String get categoryName {
    switch (category) {
      case BMICategory.underweight:
        return 'Underweight';
      case BMICategory.normal:
        return 'Normal';
      case BMICategory.overweight:
        return 'Overweight';
      case BMICategory.obeseClass1:
        return 'Obese (Class I)';
      case BMICategory.obeseClass2:
        return 'Obese (Class II)';
      case BMICategory.obeseClass3:
        return 'Obese (Class III)';
    }
  }

  // Get color associated with the BMI category
  Color get categoryColor {
    switch (category) {
      case BMICategory.underweight:
        return AppTheme.underweightColor;
      case BMICategory.normal:
        return AppTheme.normalColor;
      case BMICategory.overweight:
        return AppTheme.warningColor;
      case BMICategory.obeseClass1:
      case BMICategory.obeseClass2:
      case BMICategory.obeseClass3:
        return AppTheme.errorColor;
    }
  }

  // Get health recommendations based on BMI category
  String get healthRecommendation {
    switch (category) {
      case BMICategory.underweight:
        return 'Your BMI suggests you are underweight. Consider consulting with a healthcare provider about a balanced diet to gain weight healthily. Focus on nutrient-dense foods and strength training exercises.';

      case BMICategory.normal:
        return 'Your BMI is within the normal range. Maintain your healthy weight through balanced nutrition and regular physical activity. Aim for at least 150 minutes of moderate exercise per week.';

      case BMICategory.overweight:
        return 'Your BMI indicates you are overweight. Consider making dietary adjustments and increasing physical activity. Aim to reduce calorie intake moderately and exercise regularly to achieve a healthier weight.';

      case BMICategory.obeseClass1:
        return 'Your BMI indicates Class I obesity. It\'s recommended to consult with healthcare providers about weight management strategies. Focus on a balanced diet, regular exercise, and possibly behavioral therapy.';

      case BMICategory.obeseClass2:
        return 'Your BMI indicates Class II obesity. It\'s strongly advised to seek medical guidance for a comprehensive weight management plan. This may include dietary changes, increased physical activity, and possibly medical interventions.';

      case BMICategory.obeseClass3:
        return 'Your BMI indicates Class III obesity. Please consult with healthcare providers immediately for specialized medical attention. A comprehensive approach including medical supervision, dietary changes, and appropriate physical activity is recommended.';
    }
  }

  // Get a map representation of this BMI record
  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
      'date': date.millisecondsSinceEpoch,
      'bmiValue': bmiValue,
      'category': category.index,
    };
  }

  // Create a BMI record from a map
  factory BMIModel.fromMap(Map<String, dynamic> map) {
    final bmi = BMIModel(
      height: map['height'],
      weight: map['weight'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
    return bmi;
  }
}
