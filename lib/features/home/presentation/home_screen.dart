import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/category_model.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_state.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StadiumCubit>().loadAll();
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileInitial) {
      context.read<ProfileCubit>().getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StadiumCubit, StadiumState>(
          builder: (context, stadiumState) {
            return CustomScrollView(
              slivers: [
                _buildHeader(context),
                _buildSearchBar(context),
                _buildCategoriesTitle(context),
                _buildCategories(context, stadiumState),
                _buildStadiumsHeader(context, stadiumState),
                _buildStadiumsList(context, stadiumState),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.go(AppRoutes.profile),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  String? avatarUrl;
                  if (state is ProfileLoaded) avatarUrl = state.user.profilePictureUrl;
                  if (state is ProfileUpdateSuccess) avatarUrl = state.user.profilePictureUrl;
                  return CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceLight,
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? CachedNetworkImageProvider(avatarUrl)
                        : null,
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  );
                },
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    String name = '';
                    if (state is ProfileLoaded) name = state.user.displayName.split(' ').first;
                    if (state is ProfileUpdateSuccess) name = state.user.displayName.split(' ').first;
                    return Text(
                      name.isNotEmpty ? 'مرحباً، $name' : 'مرحباً',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    );
                  },
                ),
                Text(
                  AppStrings.appFullName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
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
              prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 22),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesTitle(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            AppStrings.categories,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, StadiumState state) {
    if (state is! StadiumLoaded) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ),
      );
    }

    final categories = state.categories;
    final selectedId = state.selectedCategoryId;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: categories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            if (index == 0) {
              return _CategoryCard(
                icon: Icons.apps_rounded,
                label: 'الكل',
                isSelected: selectedId == null,
                onTap: () => context.read<StadiumCubit>().clearFilter(),
              );
            }
            final cat = categories[index - 1];
            return _CategoryCard(
              icon: _iconForCategory(cat.name),
              label: cat.name,
              isSelected: selectedId == cat.id,
              onTap: () => context.read<StadiumCubit>().filterByCategory(cat.id, cat.name),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStadiumsHeader(BuildContext context, StadiumState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (state is StadiumLoaded)
              Text(
                '${state.filtered.length} ملعب',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              )
            else
              const SizedBox.shrink(),
            Text(
              'الملاعب المتاحة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStadiumsList(BuildContext context, StadiumState state) {
    if (state is StadiumLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (state is StadiumError) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(state.message, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<StadiumCubit>().loadAll(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is StadiumLoaded) {
      final pitches = state.filtered;
      if (pitches.isEmpty) {
        return const SliverFillRemaining(
          child: Center(
            child: Text('لا توجد ملاعب في هذه الفئة', style: TextStyle(color: AppColors.textSecondary)),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        sliver: SliverList.separated(
          itemCount: pitches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            final pitch = pitches[index];
            return _CompactPitchTile(
              pitch: pitch,
              onTap: () => context.push('/pitch/${pitch.id}'),
            );
          },
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('قدم') || lower.contains('football') || lower.contains('soccer')) {
      return Icons.sports_soccer;
    }
    if (lower.contains('سلة') || lower.contains('basket')) {
      return Icons.sports_basketball;
    }
    if (lower.contains('تنس') || lower.contains('tennis')) {
      return Icons.sports_tennis;
    }
    if (lower.contains('طائر') || lower.contains('badminton') || lower.contains('volley')) {
      return Icons.sports_volleyball;
    }
    return Icons.sports;
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
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryMuted : Colors.transparent,
              ),
              child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (pitch.location.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            pitch.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                        ],
                      ),
                    const SizedBox(height: 6),
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
              width: 130,
              height: double.infinity,
              child: pitch.imageUrl.isNotEmpty
                  ? CachedNetworkImage(imageUrl: pitch.imageUrl, fit: BoxFit.cover)
                  : Container(color: AppColors.surfaceBorder, child: const Icon(Icons.sports_soccer, size: 40, color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}
