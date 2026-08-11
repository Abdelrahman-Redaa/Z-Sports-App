import 'package:flutter/material.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.textColor,
    this.height = 54,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? textColor;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? AppColors.textPrimary;

    return SizedBox(
      width: compact ? null : double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: fg,
          elevation: 0,
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compact ? 24 : 16),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: compact ? 14 : 16,
                      fontWeight: FontWeight.w800,
                      color: fg,
                      height: 1.25,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 20, color: fg),
                  ],
                ],
              ),
      ),
    );
  }
}

class BookNowButton extends StatelessWidget {
  const BookNowButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 20, color: AppColors.background),
          SizedBox(width: 6),
          Text(
            'احجز الآن',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }
}
