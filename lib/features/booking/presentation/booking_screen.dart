import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Selected date (start from today)
  int _selectedDayIndex = 2; // default: Tuesday (index 2 like in the design → "الثلاثاء 3")
  String? _selectedTime;

  // Morning slots
  final List<String> _morningSlots = ['8:00 ص', '9:00 ص', '10:00 ص', '11:00 ص'];
  // Evening slots  
  final List<String> _eveningSlots = ['4:00 م', '5:00 م', '6:00 م', '7:00 م', '8:00 م', '9:00 م'];

  // Build the 5-day list starting from today (like the design: الأحد 1, الاثنين 2, الثلاثاء 3, ...)
  List<DateTime> get _days {
    final now = DateTime.now();
    return List.generate(7, (i) => now.add(Duration(days: i)));
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
    final pitch = MockData.pitchById(widget.pitchId);
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
            // === Date Picker Header ===
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // === Day Selector ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                days.length > 5 ? 5 : days.length,
                (index) {
                  final date = days[index];
                  final isSelected = _selectedDayIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedDayIndex = index;
                      _selectedTime = null;
                    }),
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
                },
              ),
            ),
            const SizedBox(height: 32),

            // === Morning Section ===
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الفترة الصباحية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.wb_sunny_outlined, color: AppColors.warning, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            _buildTimeSlotsGrid(_morningSlots),
            const SizedBox(height: 28),

            // === Evening Section ===
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الفترة المسائية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.nights_stay_outlined, color: AppColors.primary, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            _buildTimeSlotsGrid(_eveningSlots),
            const SizedBox(height: 32),

            // === Summary Row ===
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        'سعر الساعة',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1 ساعة',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        'مدة الحجز',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        'المجموع الكلي',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // === Confirm Button ===
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, size: 22),
                label: const Text(
                  'تأكيد الحجز',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                onPressed: _selectedTime != null
                    ? () {
                        final dateStr = DateFormat('yyyy-MM-dd').format(days[_selectedDayIndex]);
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

  Widget _buildTimeSlotsGrid(List<String> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: slots.length,
      itemBuilder: (_, index) {
        final time = slots[index];
        final isSelected = _selectedTime == time;

        return GestureDetector(
          onTap: () => setState(() => _selectedTime = isSelected ? null : time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              time,
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
