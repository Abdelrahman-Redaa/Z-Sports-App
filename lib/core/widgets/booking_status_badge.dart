import 'package:flutter/material.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/booking_model.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      BookingStatus.upcoming => ('قادمة', AppColors.primary),
      BookingStatus.completed => ('مكتملة', AppColors.textMuted),
      BookingStatus.cancelled => ('ملغية', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
