import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:z_sports_booking/core/di.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_state.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_state.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDayIndex = 0;
  String? _selectedTime;
  
  late final StadiumCubit _stadiumCubit;
  
  List<DateTime> get _days {
    final now = DateTime.now();
    return List.generate(7, (i) => now.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();
    _stadiumCubit = StadiumCubit(DI.stadiumRepository);
    _stadiumCubit.loadStadiumById(int.tryParse(widget.pitchId) ?? 0);
    _loadSlotsForSelectedDay();
  }

  @override
  void dispose() {
    _stadiumCubit.close();
    super.dispose();
  }

  void _loadSlotsForSelectedDay() {
    final dateStr = DateFormat('yyyy-MM-dd').format(_days[_selectedDayIndex]);
    context.read<BookingCubit>().loadAvailableSlots(
      int.tryParse(widget.pitchId) ?? 0, 
      dateStr,
    );
  }

  String _dayName(DateTime date) {
    const names = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return names[date.weekday % 7];
  }

  String get _monthName {
    const months = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return months[_days[_selectedDayIndex].month];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _stadiumCubit,
      child: BlocBuilder<StadiumCubit, StadiumState>(
        builder: (context, state) {
          if (state is StadiumDetailLoading || state is StadiumInitial) {
            return Scaffold(
              appBar: AppBar(title: const Text('جاري التحميل...'), centerTitle: true),
              body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            );
          }
          if (state is StadiumError) {
            return Scaffold(
              appBar: AppBar(title: const Text('خطأ'), centerTitle: true),
              body: Center(child: Text(state.message)),
            );
          }
          final pitch = (state as StadiumDetailLoaded).stadium;
          return _buildContent(context, pitch);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PitchModel pitch) {
    final days = _days;

    return Scaffold(
      appBar: AppBar(
        title: Text('حجز ${pitch.category}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _monthName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'اختر التاريخ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(days.length > 5 ? 5 : days.length, (index) {
                final date = days[index];
                final isSelected = _selectedDayIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                      _selectedTime = null;
                    });
                    _loadSlotsForSelectedDay();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayName(date),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isSelected ? AppColors.background : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          date.day.toString(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            
            BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                if (state is BookingSlotsLoading) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  );
                }
                
                // Fallback slots if API fails or returns empty
                const fallbackSlots = [
                  '08:00:00', '09:00:00', '10:00:00', '11:00:00',
                  '16:00:00', '17:00:00', '18:00:00', '19:00:00',
                  '20:00:00', '21:00:00'
                ];

                List<String> slots = fallbackSlots;
                if (state is BookingSlotsLoaded && state.availableSlots.isNotEmpty) {
                  slots = state.availableSlots;
                }

                // If API returns times like "14:00:00", we can format them, but for now we just show what API returns
                // or we can try to format them if they are in "HH:mm:ss" format.
                final formattedSlots = slots.map((s) {
                  try {
                    if (s.contains(':')) {
                      final parts = s.split(':');
                      final h = int.parse(parts[0]);
                      final m = parts[1];
                      final suffix = h >= 12 ? 'م' : 'ص';
                      final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
                      return '$h12:$m $suffix';
                    }
                  } catch (e) {
                    // ignore
                  }
                  return s;
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'المواعيد المتاحة',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTimeSlotsGrid(formattedSlots, slots),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 32),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text('سعر الساعة', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1 ساعة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      Text('مدة الحجز', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.surfaceBorder),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${pitch.pricePerHour.toInt()} ج.م',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                      ),
                      Text('المجموع الكلي', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, size: 22),
                label: const Text('متابعة الدفع', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                onPressed: _selectedTime != null
                    ? () {
                        final dateStr = DateFormat('yyyy-MM-dd').format(_days[_selectedDayIndex]);
                        context.push(
                          '/pitch/${widget.pitchId}/checkout?date=$dateStr&time=$_selectedTime',
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  disabledBackgroundColor: AppColors.surfaceLight,
                  disabledForegroundColor: AppColors.textMuted,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid(List<String> displaySlots, List<String> originalSlots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: displaySlots.length,
      itemBuilder: (_, index) {
        final displayTime = displaySlots[index];
        final rawTime = originalSlots[index];
        final isSelected = _selectedTime == rawTime;

        return GestureDetector(
          onTap: () => setState(() => _selectedTime = isSelected ? null : rawTime),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              displayTime,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }
}
