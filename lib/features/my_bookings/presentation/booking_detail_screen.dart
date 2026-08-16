import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/router/navigation_helper.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/booking_model.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_state.dart';

const _bg = AppColors.background;
const _surface = AppColors.surface;
const _border = AppColors.surfaceBorder;
const _primary = AppColors.primary;
const _textPrimary = AppColors.textPrimary;
const _textSecondary = AppColors.textSecondary;

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({
    super.key,
    required this.pitchName,
    required this.pitchImage,
    required this.date,
    required this.time,
    required this.price,
    required this.bookingId,
    this.status = '',
  });

  final String pitchName;
  final String pitchImage;
  final String date;
  final String time;
  final String price;
  final String bookingId;
  final String status;

  String _statusLabel(BuildContext context) {
    if (status == BookingStatus.completed.name) {
      return context.tr('مكتمل', 'Completed');
    }
    if (status == BookingStatus.cancelled.name) {
      return context.tr('ملغي', 'Cancelled');
    }
    return context.tr('مؤكد', 'Confirmed');
  }

  Color get _statusColor {
    if (status == BookingStatus.completed.name) return const Color(0xFF4A9EFF);
    if (status == BookingStatus.cancelled.name) return const Color(0xFFD66A65);
    return _primary;
  }

  bool get _canCancel =>
      status == BookingStatus.upcoming.name ||
      status == BookingStatus.pendingPayment.name ||
      status == '';

  Future<void> _shareBooking(BuildContext context) async {
    final displayPitchName = pitchName.isNotEmpty
        ? pitchName
        : context.tr('ملعب رياضي', 'Sports Field');
    final displayPrice = price.trim().isNotEmpty ? price : '0';
    final shareText = context.tr(
      'تفاصيل حجزي في Z Sports Booking\n\n'
          'الملعب: $displayPitchName\n'
          'رقم الحجز: #$bookingId\n'
          'التاريخ: $date\n'
          'الوقت: $time\n'
          'التكلفة: $displayPrice ج.م\n'
          'الحالة: ${_statusLabel(context)}',
      'My booking details on Z Sports Booking\n\n'
          'Field: $displayPitchName\n'
          'Booking No.: #$bookingId\n'
          'Date: $date\n'
          'Time: $time\n'
          'Cost: EGP $displayPrice\n'
          'Status: ${_statusLabel(context)}',
    );

    try {
      await SharePlus.instance.share(ShareParams(text: shareText));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr(
              'تعذر فتح المشاركة، حاول مرة أخرى.',
              'Could not open sharing, please try again.',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _surface,
        title: Text(
          context.tr('إلغاء الحجز', 'Cancel Booking'),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        content: Text(
          context.tr(
            'هل أنت متأكد من إلغاء هذا الحجز؟',
            'Are you sure you want to cancel this booking?',
          ),
          style: const TextStyle(color: _textSecondary),
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              context.tr('تراجع', 'Back'),
              style: const TextStyle(color: _textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MyBookingsCubit>().cancelBooking(
                int.tryParse(bookingId) ?? 0,
              );
            },
            child: Text(
              context.tr('نعم، إلغاء', 'Yes, Cancel'),
              style: const TextStyle(
                color: Color(0xFFD66A65),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBookingsCubit, MyBookingsState>(
      listener: (context, state) {
        if (state is BookingCancelSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.tr(
                  'تم إلغاء الحجز بنجاح',
                  'Booking cancelled successfully',
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (state is MyBookingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          centerTitle: true,
          title: Text(
            context.tr('تفاصيل الحجز', 'Booking Details'),
            style: const TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _surface,
              ),
              child: IconButton(
                icon: const Icon(Icons.share, color: _textPrimary, size: 20),
                onPressed: () => _shareBooking(context),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _surface,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: _textPrimary,
                    size: 20,
                  ),
                  onPressed: () => popOrGo(context, AppRoutes.bookings),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image with overlays
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    if (pitchImage.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: pitchImage,
                        height: 210,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => _buildPlaceholderImage(),
                      )
                    else
                      _buildPlaceholderImage(),

                    // Gradient overlay for better text readability
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Text(
                        pitchName.isNotEmpty
                            ? pitchName
                            : context.tr('ملعب رياضي', 'Sports Field'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: AppColors.backgroundOverlay,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _statusLabel(context),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Booking ID and Price
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            context.tr('التكلفة', 'Cost'),
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$price ج.م',
                            style: const TextStyle(
                              color: _primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            context.tr('رقم الحجز', 'Booking No.'),
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '#$bookingId',
                            style: const TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Date and Time
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                context.tr('التاريخ', 'Date'),
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                date,
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF222B3A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: _primary,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: _border, height: 1),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                context.tr('الوقت', 'Time'),
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                time,
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF222B3A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: _primary,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              if (_canCancel) ...[
                BlocBuilder<MyBookingsCubit, MyBookingsState>(
                  builder: (context, state) {
                    final isLoading = state is BookingCancelLoading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _showCancelConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF25191C,
                        ), // Dark red tinted background
                        foregroundColor: const Color(0xFFD66A65),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFFD66A65),
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.tr('إلغاء الحجز', 'Cancel Booking'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.cancel_outlined, size: 20),
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr(
                    'تطبق سياسة الإلغاء. الإلغاء بعد مرور 24 ساعة من تاريخ الحجز اكثر من ثلاث مرات قد يعرضك لرسوم اضافية للحجز مره اخري .',
                    'Cancellation policy applies. Repeated late cancellations may add extra fees to future bookings.',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFD66A65),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 220,
      width: double.infinity,
      color: _surface,
      child: const Icon(Icons.sports_soccer, size: 80, color: _primary),
    );
  }
}
