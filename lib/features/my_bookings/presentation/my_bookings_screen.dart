import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/booking_model.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_state.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_state.dart';

const _bg = AppColors.background;
const _surface = AppColors.surface;
const _primary = AppColors.primary;
const _textPrimary = AppColors.textPrimary;
const _textSecondary = AppColors.textSecondary;

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyBookingsCubit>().loadMyBookings();
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.tryParse(raw);
      if (dt == null) return raw;
      const months = [
        '',
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      return '${dt.day} ${months[dt.month]}';
    } catch (_) {
      return raw;
    }
  }

  String _formatTime(String raw) {
    try {
      if (raw.isEmpty) return '';
      final parts = raw.split(':');
      final h = int.parse(parts[0]);
      final m = parts.length > 1 ? parts[1] : '00';
      final suffix = h >= 12 ? 'م' : 'ص';
      final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$h12:$m $suffix';
    } catch (_) {
      return raw;
    }
  }

  IconData _iconForCategory(String category) {
    final c = category.toLowerCase();
    if (c.contains('كرة قدم') || c.contains('football') || c.contains('soccer'))
      return Icons.sports_soccer;
    if (c.contains('كرة سلة') || c.contains('basket'))
      return Icons.sports_basketball;
    if (c.contains('تنس') || c.contains('tennis')) return Icons.sports_tennis;
    if (c.contains('كرة طائرة') || c.contains('volley'))
      return Icons.sports_volleyball;
    if (c.contains('باد') || c.contains('padel')) return Icons.sports_tennis;
    return Icons.sports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final name = state is ProfileLoaded
                          ? state.user.displayName.split(' ').first
                          : 'مستخدم';
                      final avatar = state is ProfileLoaded
                          ? (state.user.profilePictureUrl ?? '')
                          : '';
                      return Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'مرحباً، $name',
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const Text(
                                'Z Sports Booking',
                                style: TextStyle(
                                  color: _primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: _surface,
                            backgroundImage: avatar.isNotEmpty
                                ? NetworkImage(avatar)
                                : null,
                            child: avatar.isEmpty
                                ? const Icon(Icons.person, color: _primary)
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'حجوزاتي',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'إدارة نشاطاتك الرياضية القادمة',
                textAlign: TextAlign.right,
                style: TextStyle(color: _textSecondary, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
                builder: (context, state) {
                  if (state is MyBookingsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: _primary),
                    );
                  }

                  if (state is MyBookingsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: _textSecondary,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(color: _textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context
                                .read<MyBookingsCubit>()
                                .loadMyBookings(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: _bg,
                            ),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  List<BookingModel> bookings = [];
                  if (state is MyBookingsLoaded) bookings = state.bookings;
                  if (state is BookingCancelLoading) bookings = state.bookings;
                  if (state is BookingCancelSuccess) bookings = state.bookings;

                  if (bookings.isEmpty) {
                    return RefreshIndicator(
                      color: _primary,
                      backgroundColor: _surface,
                      onRefresh: () =>
                          context.read<MyBookingsCubit>().loadMyBookings(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sports_soccer,
                                    color: _textSecondary,
                                    size: 80,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'لا توجد حجوزات حتى الآن',
                                    style: TextStyle(
                                      color: _textSecondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'احجز ملعبك المفضل الآن!',
                                    style: TextStyle(
                                      color: _textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: _primary,
                    backgroundColor: _surface,
                    onRefresh: () =>
                        context.read<MyBookingsCubit>().loadMyBookings(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      itemCount: bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (ctx, index) {
                        final booking = bookings[index];
                        return _BookingCard(
                          booking: booking,
                          formattedDate: _formatDate(booking.date),
                          formattedTime: _formatTime(booking.time),
                          icon: _iconForCategory(booking.category),
                          onTap: () => context.push(
                            AppRoutes.bookingDetail,
                            extra: {
                              'pitchName': booking.stadiumName,
                              'pitchImage': booking.stadiumImage,
                              'date': _formatDate(booking.date),
                              'time':
                                  '${_formatTime(booking.time)} (${booking.durationMinutes} دقيقة)',
                              'price': booking.totalPrice.toInt().toString(),
                              'bookingId': booking.id.toString(),
                              'status': booking.status.name,
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.formattedDate,
    required this.formattedTime,
    required this.icon,
    required this.onTap,
  });

  final BookingModel booking;
  final String formattedDate;
  final String formattedTime;
  final IconData icon;
  final VoidCallback onTap;

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 'مؤكد';
      case BookingStatus.completed:
        return 'مكتمل';
      case BookingStatus.cancelled:
        return 'ملغي';
    }
  }

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return _primary;
      case BookingStatus.completed:
        return const Color(0xFF4A9EFF);
      case BookingStatus.cancelled:
        return const Color(0xFFD66A65);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _statusColor, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    booking.stadiumName.isNotEmpty
                        ? booking.stadiumName
                        : 'ملعب رياضي',
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    booking.category.isNotEmpty
                        ? booking.category
                        : 'Z Sports ملاعب',
                    style: const TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _surface,
                ),
                child: Icon(icon, color: _statusColor, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (formattedTime.isNotEmpty) ...[
                Text(
                  formattedTime,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.access_time, color: _statusColor, size: 18),
                const SizedBox(width: 16),
              ],
              if (formattedDate.isNotEmpty) ...[
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.calendar_today, color: _statusColor, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _statusColor,
                foregroundColor: _bg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'عرض تفاصيل الحجز',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
