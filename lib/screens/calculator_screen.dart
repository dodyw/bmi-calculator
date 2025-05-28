import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bmi_provider.dart';
import '../widgets/measurement_input.dart';
import '../widgets/bmi_gauge.dart';
import '../widgets/bmi_category_card.dart';
import '../utils/app_theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();
  bool _showResult = false;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _heightFocusNode.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bmiProvider = Provider.of<BMIProvider>(context);
    final isMetric = bmiProvider.isMetric;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: Icon(isMetric ? Icons.straighten : Icons.height),
            onPressed: () {
              bmiProvider.toggleUnitSystem();
              // Clear inputs when changing unit system
              _heightController.clear();
              _weightController.clear();
              setState(() {
                _showResult = false;
              });
            },
            tooltip: isMetric ? 'Switch to Imperial' : 'Switch to Metric',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputForm(isMetric),
              const SizedBox(height: 24),
              if (_showResult && bmiProvider.currentBMI != null) ...[
                BMIGauge(bmiModel: bmiProvider.currentBMI!),
                const SizedBox(height: 16),
                BMICategoryCard(bmiModel: bmiProvider.currentBMI!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm(bool isMetric) {
    final heightUnit = isMetric ? 'cm' : 'in';
    final weightUnit = isMetric ? 'kg' : 'lb';
    final heightLabel = 'Height';
    final weightLabel = 'Weight';

    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Your Measurements',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Using ${isMetric ? 'Metric' : 'Imperial'} Units',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              MeasurementInput(
                label: heightLabel,
                unit: heightUnit,
                controller: _heightController,
                icon: Icons.height,
                focusNode: _heightFocusNode,
                onEditingComplete: () => _weightFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  final height = double.tryParse(value);
                  if (height == null || height <= 0) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
                helperText:
                    isMetric
                        ? 'Example: 175 for 175 cm'
                        : 'Example: 69 for 5\'9"',
              ),
              const SizedBox(height: 16),
              MeasurementInput(
                label: weightLabel,
                unit: weightUnit,
                controller: _weightController,
                icon: Icons.monitor_weight,
                focusNode: _weightFocusNode,
                onEditingComplete: _calculateBMI,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                helperText:
                    isMetric
                        ? 'Example: 70 for 70 kg'
                        : 'Example: 154 for 154 lb',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'CALCULATE BMI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateBMI() {
    if (_formKey.currentState?.validate() ?? false) {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);

      final bmiProvider = Provider.of<BMIProvider>(context, listen: false);
      bmiProvider.calculateBMI(height: height, weight: weight);

      setState(() {
        _showResult = true;
      });

      // Hide keyboard
      FocusScope.of(context).unfocus();
    }
  }
}
