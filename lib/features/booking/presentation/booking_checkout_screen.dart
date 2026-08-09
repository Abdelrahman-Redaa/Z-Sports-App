import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/di.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_state.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_state.dart';

class BookingCheckoutScreen extends StatefulWidget {
  const BookingCheckoutScreen({
    super.key,
    required this.pitchId,
    required this.date,
    required this.time,
  });

  final String pitchId;
  final String date;
  final String time;

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
  int _selectedPayment = 0;
  static const _instapayNumber = '01012345678';
  late final StadiumCubit _stadiumCubit;

  @override
  void initState() {
    super.initState();
    _stadiumCubit = StadiumCubit(DI.stadiumRepository);
    _stadiumCubit.loadStadiumById(int.tryParse(widget.pitchId) ?? 0);
  }

  @override
  void dispose() {
    _stadiumCubit.close();
    super.dispose();
  }

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    const months = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return '${parsed.day} ${months[parsed.month]} ${parsed.year}';
  }
  
  String _formatTime(String rawTime) {
    try {
      if (rawTime.contains(':')) {
        final parts = rawTime.split(':');
        final h = int.parse(parts[0]);
        final m = parts[1];
        final suffix = h >= 12 ? 'م' : 'ص';
        final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        return '$h12:$m $suffix';
      }
    } catch (e) {
      // ignore
    }
    return rawTime.isNotEmpty ? rawTime : '08:00 م';
  }

  void _submitBooking() {
    // Ensure time is in HH:mm:ss format (e.g. "14:00:00")
    String rawTime = widget.time;
    if (!rawTime.contains(':')) rawTime = '08:00:00';
    final parts = rawTime.split(':');
    final timeFormatted = parts.length >= 2
        ? '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:${parts.length > 2 ? parts[2] : '00'}'
        : rawTime;

    // Ensure date is in ISO datetime format
    final dateFormatted = widget.date.contains('T')
        ? widget.date
        : '${widget.date}T00:00:00';

    context.read<BookingCubit>().submitBooking(
      stadiumId: int.tryParse(widget.pitchId) ?? 0,
      date: dateFormatted,
      time: timeFormatted,
      durationMinutes: 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _stadiumCubit,
      child: BlocBuilder<StadiumCubit, StadiumState>(
        builder: (context, state) {
          if (state is StadiumDetailLoading || state is StadiumInitial) {
            return Scaffold(
              appBar: AppBar(backgroundColor: AppColors.background, title: const Text('إتمام الدفع', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            );
          }

          if (state is StadiumError) {
             return Scaffold(
              appBar: AppBar(backgroundColor: AppColors.background, title: const Text('إتمام الدفع', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              body: Center(child: Text(state.message, style: const TextStyle(color: Colors.white))),
            );
          }

          final pitch = (state as StadiumDetailLoaded).stadium;
          return _buildContent(context, pitch);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PitchModel pitch) {
    final formattedDate = _formatDate(widget.date);
    final displayTime = _formatTime(widget.time);
    
    // Calculate end time
    String endTime = '09:00 م';
    try {
      if (widget.time.contains(':')) {
        final parts = widget.time.split(':');
        var h = int.parse(parts[0]) + 1; // add 1 hour duration
        if (h >= 24) h = 0;
        final m = parts[1];
        final suffix = h >= 12 ? 'م' : 'ص';
        final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        endTime = '$h12:$m $suffix';
      }
    } catch (e) {
      // ignore
    }
    final timeRange = '$displayTime - $endTime';

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSubmitSuccess) {
          final pitchName = Uri.encodeComponent(pitch.name);
          final encodedDate = Uri.encodeComponent(formattedDate);
          final encodedTime = Uri.encodeComponent(timeRange);
          context.pushReplacement('${AppRoutes.bookingSuccess}?pitchName=$pitchName&date=$encodedDate&time=$encodedTime');
        } else if (state is BookingSubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'إتمام الدفع',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'ملخص الحجز',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 130,
                      child: CachedNetworkImage(
                        imageUrl: pitch.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, size: 40, color: AppColors.textMuted),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pitch.category.isNotEmpty ? pitch.category : 'رياضة',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pitch.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formattedDate, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                const SizedBox(width: 6),
                                const Icon(Icons.calendar_today, size: 13, color: AppColors.textSecondary),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(timeRange, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                const SizedBox(width: 6),
                                const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('طريقة الدفع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
              ),
              const SizedBox(height: 16),
              _PaymentOption(
                icon: Icons.credit_card,
                title: 'انستا باي',
                subtitle: 'دفع سريع وآمن بلمسة واحدة',
                isSelected: _selectedPayment == 0,
                onTap: () => setState(() => _selectedPayment = 0),
              ),
              const SizedBox(height: 12),
              _PaymentOption(
                icon: Icons.payments_outlined,
                title: 'الدفع عند اللعب',
                isSelected: _selectedPayment == 1,
                onTap: () => setState(() => _selectedPayment = 1),
              ),
              const SizedBox(height: 24),
              if (_selectedPayment == 0) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: _instapayNumber));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ رقم التحويل')));
                            },
                            child: const Icon(Icons.copy, size: 18, color: AppColors.primary),
                          ),
                          const Text('رقم التحويل', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _instapayNumber,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: AppColors.surfaceBorder),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pitch.pricePerHour.toInt()} ج.م',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 22),
                          ),
                          const Text('المجموع الكلي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1719),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF382023)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.error_outline, color: Color(0xFFD66A65), size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ارسل صورة التحويل على واتساب على نفس رقم التحويل لتأكيد الحجز فوراً.',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Color(0xFFD66A65), fontSize: 13, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pitch.pricePerHour.toInt()} ج.م',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          const Text('قيمة الحجز', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: AppColors.surfaceBorder),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pitch.pricePerHour.toInt()} ج.م',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 22),
                          ),
                          const Text('المجموع الكلي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          color: AppColors.background,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                final isLoading = state is BookingSubmitLoading;
                return ElevatedButton.icon(
                  icon: isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: AppColors.background, strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline, size: 22),
                  label: Text(
                    isLoading ? 'جاري التأكيد...' : 'تأكيد الحجز',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  onPressed: isLoading ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.circle, size: 10, color: Colors.white) : null,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ],
            ),
            const SizedBox(width: 16),
            Icon(icon, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }
}
