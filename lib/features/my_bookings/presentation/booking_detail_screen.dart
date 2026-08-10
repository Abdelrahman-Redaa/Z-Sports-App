import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/booking_model.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_state.dart';

const _bg = Color(0xFF131923);
const _surface = Color(0xFF1B222C);
const _border = Color(0xFF242C37);
const _primary = Color(0xFF39FF14);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF8A96A3);

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

  String get _statusLabel {
    if (status == BookingStatus.completed.name) return 'مكتمل';
    if (status == BookingStatus.cancelled.name) return 'ملغي';
    return 'مؤكد';
  }

  Color get _statusColor {
    if (status == BookingStatus.completed.name) return const Color(0xFF4A9EFF);
    if (status == BookingStatus.cancelled.name) return const Color(0xFFD66A65);
    return _primary;
  }

  bool get _canCancel => status == BookingStatus.upcoming.name || status == '';

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _surface,
        title: const Text('إلغاء الحجز', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد من إلغاء هذا الحجز؟', style: TextStyle(color: _textSecondary), textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('تراجع', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MyBookingsCubit>().cancelBooking(int.tryParse(bookingId) ?? 0);
            },
            child: const Text('نعم، إلغاء', style: TextStyle(color: Color(0xFFD66A65), fontWeight: FontWeight.bold)),
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
            const SnackBar(content: Text('تم إلغاء الحجز بنجاح'), backgroundColor: Colors.green),
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
          title: const Text(
            'تفاصيل الحجز',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 20),
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
                onPressed: () {},
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
                  icon: const Icon(Icons.arrow_forward, color: _textPrimary, size: 20),
                  onPressed: () => context.pop(),
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
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    if (pitchImage.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: pitchImage,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _buildPlaceholderImage(),
                      )
                    else
                      _buildPlaceholderImage(),

                    // Gradient overlay for better text readability
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Text(
                        pitchName.isNotEmpty ? pitchName : 'ملعب رياضي',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _statusLabel,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Booking ID and Price
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          const Text('التكلفة', style: TextStyle(color: _textSecondary, fontSize: 13)),
                          const SizedBox(height: 8),
                          Text(
                            '$price ج.م',
                            style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          const Text('رقم الحجز', style: TextStyle(color: _textSecondary, fontSize: 13)),
                          const SizedBox(height: 8),
                          Text(
                            '#$bookingId',
                            style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Date and Time
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(28),
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
                              const Text('التاريخ', style: TextStyle(color: _textSecondary, fontSize: 14)),
                              const SizedBox(height: 6),
                              Text(
                                date,
                                style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 16),
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
                          child: const Icon(Icons.calendar_today, color: _primary, size: 22),
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
                              const Text('الوقت', style: TextStyle(color: _textSecondary, fontSize: 14)),
                              const SizedBox(height: 6),
                              Text(
                                time,
                                style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 16),
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
                          child: const Icon(Icons.access_time, color: _primary, size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              if (_canCancel) ...[
                BlocBuilder<MyBookingsCubit, MyBookingsState>(
                  builder: (context, state) {
                    final isLoading = state is BookingCancelLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : () => _showCancelConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25191C), // Dark red tinted background
                        foregroundColor: const Color(0xFFD66A65),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Color(0xFFD66A65), strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'إلغاء الحجز',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.cancel_outlined, size: 20),
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'تطبق سياسة الإلغاء. الإلغاء بعد مرور 24 ساعة من تاريخ الحجز اكثر من ثلاث مرات قد يعرضك لرسوم اضافية للحجز مره اخري .',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
