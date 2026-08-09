import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

enum SportType { all, football, basketball, tennis }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SportType _selectedSport = SportType.football;

  List<PitchModel> get _filteredPitches {
    switch (_selectedSport) {
      case SportType.all:
        return MockData.pitches;
      case SportType.football:
        return MockData.pitches
            .where(
              (p) => p.category.contains('قدم') || p.category.contains('ضد'),
            )
            .toList();
      case SportType.basketball:
        return MockData.pitches
            .where((p) => p.category.contains('سلة'))
            .toList();
      case SportType.tennis:
        return MockData.pitches
            .where((p) => p.category.contains('تنس'))
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.profile),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: CachedNetworkImageProvider(
                          MockData.currentUser.avatarUrl,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'مرحباً، ${MockData.currentUser.name.split(' ').first}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          AppStrings.appFullName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: TextField(
                    readOnly: true,
                    onTap: () => context.go(AppRoutes.search),
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: AppStrings.searchHint,
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.categories,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _CategoryCard(
                        icon: Icons.sports_soccer,
                        label: 'قدم',
                        isSelected: _selectedSport == SportType.football,
                        onTap: () =>
                            setState(() => _selectedSport = SportType.football),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CategoryCard(
                        icon: Icons.sports_basketball,
                        label: 'سلة',
                        isSelected: _selectedSport == SportType.basketball,
                        onTap: () => setState(
                          () => _selectedSport = SportType.basketball,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CategoryCard(
                        icon: Icons.sports_tennis,
                        label: 'تنس',
                        isSelected: _selectedSport == SportType.tennis,
                        onTap: () =>
                            setState(() => _selectedSport = SportType.tennis),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedSport = SportType.all),
                      child: Text(
                        'الكل',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _selectedSport == SportType.all
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          decoration: _selectedSport == SportType.all
                              ? TextDecoration.underline
                              : null,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      'الملاعب المتاحة',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList.separated(
                itemCount: _filteredPitches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final pitch = _filteredPitches[index];
                  return _CompactPitchTile(
                    pitch: pitch,
                    onTap: () => context.push('/pitch/${pitch.id}'),
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryMuted : Colors.transparent,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactPitchTile extends StatelessWidget {
  const _CompactPitchTile({required this.pitch, required this.onTap});

  final PitchModel pitch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pitch.name,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${pitch.pricePerHour.toInt()} ج.م',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 140,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: pitch.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
