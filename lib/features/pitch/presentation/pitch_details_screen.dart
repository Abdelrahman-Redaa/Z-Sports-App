import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/di.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_state.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_state.dart';

class PitchDetailsScreen extends StatefulWidget {
  const PitchDetailsScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  State<PitchDetailsScreen> createState() => _PitchDetailsScreenState();
}

class _PitchDetailsScreenState extends State<PitchDetailsScreen> {
  String? _selectedTime;
  bool _isFavorite = false;
  late final StadiumCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = StadiumCubit(DI.stadiumRepository);
    final pitchId = int.tryParse(widget.pitchId) ?? 0;
    _cubit.loadStadiumById(pitchId);
    context.read<BookingCubit>().loadAvailableSlots(
      pitchId,
      DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _formatApiTimeForGrid(String raw) {
    try {
      if (raw.contains(':')) {
        final parts = raw.split(':');
        final h = int.parse(parts[0]);
        final m = parts[1];
        final suffix = h >= 12 ? 'م' : 'ص';
        final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        final paddedH = h12.toString().padLeft(2, '0');
        return '$paddedH:$m\n$suffix';
      }
    } catch (_) {}
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<StadiumCubit, StadiumState>(
        builder: (context, state) {
          if (state is StadiumDetailLoading || state is StadiumInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            );
          }

          if (state is StadiumError) {
            return Scaffold(
              appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.loadStadiumById(int.tryParse(widget.pitchId) ?? 0),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          final pitch = (state as StadiumDetailLoaded).stadium;
          return _buildContent(context, pitch);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PitchModel pitch) {
    final today = DateFormat('d MMMM', 'ar').format(DateTime.now());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                pitch.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: pitch.imageUrl,
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(height: 260, color: AppColors.surfaceLight),
                      )
                    : Container(height: 260, color: AppColors.surfaceLight,
                        child: const Icon(Icons.sports_soccer, size: 80, color: AppColors.textMuted)),
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
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 16,
                  child: _CircleIconButton(icon: Icons.arrow_forward, onTap: () => context.pop()),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFav = context.read<FavoritesCubit>().isFavorite(pitch.id);
                      return _CircleIconButton(
                        icon: isFav ? Icons.favorite : Icons.favorite_border,
                        iconColor: isFav ? const Color(0xFFEF4444) : AppColors.textPrimary,
                        onTap: () {
                          context.read<FavoritesCubit>().toggleFavorite(pitch.id);
                        },
                      );
                    },
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
                  Text(
                    pitch.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (pitch.location.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(pitch.location, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('(${pitch.reviewCount} تقييم)', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Text(pitch.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                            const Icon(Icons.star, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                      if (pitch.category.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text('•', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5))),
                        const SizedBox(width: 8),
                        Text(pitch.category, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                  if (pitch.amenities.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text('المرافق', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.end,
                      children: pitch.amenities.map((a) => _AmenityChip(label: a)).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text('عن الملعب', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pitch.description.isNotEmpty ? pitch.description : 'ملعب رياضي متاح للحجز.',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.7),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text('اليوم، $today', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      Text('المواعيد المتاحة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      if (state is BookingSlotsLoading) {
                        return const SizedBox(
                          height: 80,
                          child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                        );
                      }
                      
                      List<String> apiSlots = [];
                      if (state is BookingSlotsLoaded) {
                        apiSlots = state.availableSlots;
                      }

                      if (apiSlots.isEmpty) {
                        return const SizedBox(
                          height: 80,
                          child: Center(
                            child: Text(
                              'لا توجد مواعيد متاحة اليوم',
                              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: apiSlots.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (_, index) {
                            final rawTime = apiSlots[index];
                            final formattedTime = _formatApiTimeForGrid(rawTime);
                            final isSelected = _selectedTime == rawTime;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedTime = rawTime),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 72,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceLight,
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
                                      formattedTime.split('\n')[0],
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formattedTime.split('\n')[1],
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 160,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bolt, size: 20),
                  label: const Text(AppStrings.bookNow, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  onPressed: () => context.push('/pitch/${widget.pitchId}/book'),
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
                  Text('الإجمالي', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  Text('${pitch.pricePerHour.toInt()} ج.م/ساعة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap, this.iconColor});

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
