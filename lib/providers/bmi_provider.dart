import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_model.dart';

class BMIProvider with ChangeNotifier {
  List<BMIModel> _bmiHistory = [];
  BMIModel? _currentBMI;
  bool _isMetric = true; // true for metric (cm/kg), false for imperial (in/lbs)

  // Getters
  List<BMIModel> get bmiHistory => _bmiHistory;
  BMIModel? get currentBMI => _currentBMI;
  bool get isMetric => _isMetric;

  // Initialize the provider
  Future<void> initialize() async {
    await loadBMIHistory();
    await loadUnitPreference();
  }

  // Toggle between metric and imperial units
  Future<void> toggleUnitSystem() async {
    _isMetric = !_isMetric;
    notifyListeners();

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMetric', _isMetric);
  }

  // Load unit preference
  Future<void> loadUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isMetric = prefs.getBool('isMetric') ?? true;
    notifyListeners();
  }

  // Calculate BMI and add to history
  Future<void> calculateBMI({
    required double height,
    required double weight,
  }) async {
    // If using imperial, convert to metric for calculation
    double heightInCm = height;
    double weightInKg = weight;

    if (!_isMetric) {
      // Convert inches to cm (1 inch = 2.54 cm)
      heightInCm = height * 2.54;

      // Convert pounds to kg (1 lb = 0.45359237 kg)
      weightInKg = weight * 0.45359237;
    }

    _currentBMI = BMIModel(height: heightInCm, weight: weightInKg);

    _bmiHistory.add(_currentBMI!);
    notifyListeners();

    // Save to local storage
    await saveBMIHistory();
  }

  // Save BMI history to SharedPreferences
  Future<void> saveBMIHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = _bmiHistory.map((bmi) => bmi.toMap()).toList();
    await prefs.setString('bmi_history', jsonEncode(historyData));
  }

  // Load BMI history from SharedPreferences
  Future<void> loadBMIHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('bmi_history');

    if (historyString != null && historyString.isNotEmpty) {
      try {
        final historyData = jsonDecode(historyString) as List;
        _bmiHistory =
            historyData
                .map((item) => BMIModel.fromMap(item as Map<String, dynamic>))
                .toList();

        if (_bmiHistory.isNotEmpty) {
          _currentBMI = _bmiHistory.last;
        }

        notifyListeners();
      } catch (e) {
        debugPrint('Error loading BMI history: $e');
      }
    }
  }

  // Clear BMI history
  Future<void> clearHistory() async {
    _bmiHistory = [];
    _currentBMI = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bmi_history');
  }

  // Delete a specific BMI record
  Future<void> deleteBMIRecord(BMIModel bmi) async {
    _bmiHistory.removeWhere(
      (item) =>
          item.date.millisecondsSinceEpoch == bmi.date.millisecondsSinceEpoch,
    );

    if (_currentBMI?.date.millisecondsSinceEpoch ==
        bmi.date.millisecondsSinceEpoch) {
      _currentBMI = _bmiHistory.isNotEmpty ? _bmiHistory.last : null;
    }

    notifyListeners();
    await saveBMIHistory();
  }
}
