import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';

class PitchDetailsScreen extends StatefulWidget {
  const PitchDetailsScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  State<PitchDetailsScreen> createState() => _PitchDetailsScreenState();
}

class _PitchDetailsScreenState extends State<PitchDetailsScreen> {
  String? _selectedTime;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final pitch = MockData.pitchById(widget.pitchId);
    final today = DateFormat('d MMMM', 'ar').format(DateTime.now());

    // Evening times from the design (image 6/7/8)
    final times = ['08:00\nمساءً', '09:00\nمساءً', '10:00\nمساءً', '11:00\nمساءً'];
    final bookedIndex = 3; // last one is booked (محجوز)

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image
          SliverToBoxAdapter(
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: pitch.imageUrl,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Gradient overlay at bottom
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.background, Colors.transparent],
                      ),
                    ),
                  ),
                ),
                // Back button (arrow right → back in Arabic RTL)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 16,
                  child: _CircleIconButton(
                    icon: Icons.arrow_forward,
                    onTap: () => context.pop(),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: _CircleIconButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                    iconColor: _isFavorite ? AppColors.favorite : AppColors.textPrimary,
                    onTap: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Pitch Name
                  Text(
                    pitch.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Rating + Category Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '(${pitch.reviewCount} تقييم)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              pitch.rating.toString(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const Icon(Icons.star, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5))),
                      const SizedBox(width: 8),
                      Text(
                        pitch.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // About Pitch
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      'عن الملعب',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pitch.description,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Available Times Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            'اليوم، $today',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        'المواعيد المتاحة',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Time Slots Row
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // RTL order
                      itemCount: times.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final time = times[index];
                        final isBooked = index == bookedIndex;
                        final isSelected = _selectedTime == time;

                        return GestureDetector(
                          onTap: isBooked ? null : () => setState(() => _selectedTime = time),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 72,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  time.split('\n')[0],
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isBooked
                                            ? AppColors.textMuted
                                            : isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isBooked ? 'محجوز' : (time.split('\n').length > 1 ? time.split('\n')[1] : 'م'),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: isBooked
                                            ? AppColors.textMuted
                                            : isSelected
                                                ? AppColors.primary
                                                : AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar: Book Now + Price
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
          ),
          child: Row(
            children: [
              // Book Now Button
              SizedBox(
                width: 160,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bolt, size: 20),
                  label: Text(
                    AppStrings.bookNow,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  onPressed: () {
                    // If time selected → go to booking screen for date/time picker
                    // Otherwise go to booking screen
                    context.push('/pitch/${widget.pitchId}/book');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'الإجمالي',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    '${pitch.pricePerHour.toInt()} ج.م/ساعة',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Icon(icon, size: 20, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}
