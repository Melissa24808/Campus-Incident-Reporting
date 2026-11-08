import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}