import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/core/widgets/profile_menu_tile.dart';
import 'package:z_sports_booking/data/models/user_model.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_state.dart';

const _bg = AppColors.background;
const _surface = AppColors.surface;
const _primary = AppColors.primary;
const _textPrimary = AppColors.textPrimary;
const _textSecondary = AppColors.textSecondary;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _rewardDialogShown = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  void _maybeShowRewardDialog(UserModel? user) {
    if (_rewardDialogShown || user == null) return;
    _rewardDialogShown = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showRewardDialog(context, user.points);
    });
  }

  void _showRewardDialog(BuildContext context, int points) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.tr('إغلاق', 'Close'),
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) {
        return _RewardDialog(points: points);
      },
      transitionBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          context.tr('الملف الشخصي', 'Profile'),
          style: const TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: const TextStyle(color: _textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().getProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: AppColors.background,
                    ),
                    child: Text(context.tr('إعادة المحاولة', 'Retry')),
                  ),
                ],
              ),
            );
          }

          UserModel? user;
          if (state is ProfileLoaded) user = state.user;
          if (state is ProfileUpdating) user = state.user;
          if (state is ProfileUpdateSuccess) user = state.user;
          _maybeShowRewardDialog(user);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildAvatar(user),
                const SizedBox(height: 14),
                Text(
                  user?.displayName ?? context.tr('المستخدم', 'User'),
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr('لاعب متميز', 'Featured Player'),
                  style: const TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: '${user?.bookingsCount ?? 0}',
                        label: context.tr('حجز', 'Bookings'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, favoritesState) {
                          return _StatCard(
                            value: '${favoritesState.favoriteIds.length}',
                            label: context.tr('مفضلة', 'Favorites'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        value: '${user?.points ?? 0}',
                        label: context.tr('نقطة', 'Points'),
                        showIcon: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _ProfileActions(
                  onEditProfile: () => context.push(AppRoutes.editProfile),
                  onChangePassword: () =>
                      context.push(AppRoutes.changePassword),
                  onLogout: () {
                    context.read<AuthCubit>().logout();
                    context.go(AppRoutes.welcome);
                  },
                  onToggleLanguage: () =>
                      context.read<LanguageCubit>().toggleLanguage(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(UserModel? user) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipOval(
        child:
            user?.profilePictureUrl != null &&
                user!.profilePictureUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: user.profilePictureUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    const Icon(Icons.person, color: _primary, size: 54),
              )
            : const Icon(Icons.person, color: _primary, size: 54),
      ),
    );
  }
}

class _RewardDialog extends StatelessWidget {
  const _RewardDialog({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    final displayPoints = points > 0 ? points : 50;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.82,
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 30),
          decoration: BoxDecoration(
            color: const Color(0xFF202020),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: _primary.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: _primary.withValues(alpha: 0.18),
                blurRadius: 46,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primary.withValues(alpha: 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withValues(alpha: 0.32),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$displayPoints',
                            style: const TextStyle(
                              color: _primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 42,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.tr('نقطة', 'Points'),
                            style: const TextStyle(
                              color: _primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: -2,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF202020),
                        shape: BoxShape.circle,
                        border: Border.all(color: _primary, width: 2),
                      ),
                      child: const Icon(
                        Icons.star_border_rounded,
                        color: _primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                context.tr('تهانينا!', 'Congratulations!'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'تحصل على $displayPoints نقطة مكافأة مقابل حجزك الناجح\nعند وصول 1000 نقطة تحصل على حجز مجاني',
                  'You earned $displayPoints reward points for your successful booking.\nReach 1000 points to get a free booking.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 15,
                  height: 1.65,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: _bg,
                    elevation: 10,
                    shadowColor: _primary.withValues(alpha: 0.45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    context.tr('متابعة', 'Continue'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileActions extends StatelessWidget {
  const _ProfileActions({
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onToggleLanguage,
    required this.onLogout,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onToggleLanguage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          ProfileMenuTile(
            icon: Icons.person_outline,
            title: context.tr('تعديل الملف الشخصي', 'Edit Profile'),
            onTap: onEditProfile,
          ),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          ProfileMenuTile(
            icon: Icons.lock_outline,
            title: context.tr('تغيير كلمة المرور', 'Change Password'),
            onTap: onChangePassword,
          ),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return ProfileMenuTile(
                icon: Icons.language,
                title: context.tr('اللغة', 'Language'),
                onTap: onToggleLanguage,
                trailing: Text(
                  languageState.isEnglish ? 'English' : 'العربية',
                  style: const TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          ProfileMenuTile(
            icon: Icons.logout,
            title: context.tr('تسجيل الخروج', 'Logout'),
            iconColor: const Color(0xFFD66A65),
            textColor: const Color(0xFFD66A65),
            trailing: const SizedBox.shrink(),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.showIcon = false,
  });

  final String value;
  final String label;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: _textSecondary, fontSize: 14),
          ),
          if (showIcon) ...[
            const SizedBox(height: 8),
            const Icon(
              Icons.monetization_on_outlined,
              color: Colors.amber,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}
