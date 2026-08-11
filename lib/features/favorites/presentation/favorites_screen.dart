import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Always refresh when screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesCubit>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الملاعب المفضلة',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      if (state is FavoritesLoaded) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${state.favorites.length} ملعب',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  // ignore: avoid_print
                  print('🎯 [FavoritesScreen] BlocBuilder called. state type: ${state.runtimeType}');

                  // Loading
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  // Error
                  if (state is FavoritesError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 56),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<FavoritesCubit>().loadFavorites(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('إعادة المحاولة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Loaded with items
                  if (state is FavoritesLoaded) {
                    // ignore: avoid_print
                    print('🎯 [FavoritesScreen] FavoritesLoaded with ${state.favorites.length} items');

                    if (state.favorites.isEmpty) {
                      return _buildEmpty(context);
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.favorites.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _FavoritePitchCard(
                              pitch: state.favorites[index]);
                        },
                      ),
                    );
                  }

                  // Optimistic/Initial state
                  final optimisticList = state.favoriteList;
                  if (optimisticList != null && optimisticList.isNotEmpty) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: optimisticList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _FavoritePitchCard(pitch: optimisticList[index]);
                      },
                    );
                  }

                  return _buildEmpty(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, color: AppColors.textMuted, size: 72),
              SizedBox(height: 20),
              Text(
                'لا توجد ملاعب مفضلة',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'اضغط على ❤️ في أي ملعب لإضافته',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Favorite Pitch Card ───────────────────────────────────────────────────────

class _FavoritePitchCard extends StatelessWidget {
  const _FavoritePitchCard({required this.pitch});

  final PitchModel pitch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/pitch/${pitch.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  pitch.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: pitch.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _imagePlaceholder(),
                          placeholder: (_, __) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),

                  // Remove from favorites button (top left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<FavoritesCubit>()
                            .toggleFavorite(pitch.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xCC000000),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFEF4444),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: rating + button
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.warning, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              pitch.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () => context.push('/pitch/${pitch.id}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.background,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'احجز الآن',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Right: name + price + location
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          pitch.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${pitch.pricePerHour.toInt()} ج.م',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(
                                text: ' /ساعة',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (pitch.location.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  pitch.location,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.location_on_outlined,
                                  color: AppColors.textSecondary, size: 13),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.sports_soccer, color: AppColors.primary, size: 56),
      ),
    );
  }
}
