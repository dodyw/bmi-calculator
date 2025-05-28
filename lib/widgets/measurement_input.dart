import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

class MeasurementInput extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData icon;
  final String? helperText;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;

  const MeasurementInput({
    Key? key,
    required this.label,
    required this.unit,
    required this.controller,
    this.validator,
    required this.icon,
    this.helperText,
    this.focusNode,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      onEditingComplete: onEditingComplete,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        suffixText: unit,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppTheme.surfaceColor,
      ),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
