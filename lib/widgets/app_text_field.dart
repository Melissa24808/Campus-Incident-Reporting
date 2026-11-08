import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? prefixIconColor;
  final double borderRadius;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.hintText,
    this.fillColor,
    this.focusedBorderColor,
    this.prefixIconColor,
    this.borderRadius = 14,
    this.autofillHints,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      keyboardType: keyboardType,
      validator: validator,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: prefixIconColor),
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppTheme.primary,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}
