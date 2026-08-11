import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/core/widgets/profile_menu_tile.dart';
import 'package:z_sports_booking/data/models/user_model.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
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
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          UserModel? user;
          if (state is ProfileLoaded) user = state.user;
          if (state is ProfileUpdating) user = state.user;
          if (state is ProfileUpdateSuccess) user = state.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildAvatar(user),
                const SizedBox(height: 14),
                Text(
                  user?.displayName ?? 'المستخدم',
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'لاعب متميز',
                  style: TextStyle(
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
                        label: 'حجز',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        value: '${user?.pitchesCount ?? 0}',
                        label: 'مفضلة',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        value: '${user?.points ?? 0}',
                        label: 'نقطة',
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

class _ProfileActions extends StatelessWidget {
  const _ProfileActions({
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onLogout,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
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
            title: 'تعديل الملف الشخصي',
            onTap: onEditProfile,
          ),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          ProfileMenuTile(
            icon: Icons.lock_outline,
            title: 'تغيير كلمة المرور',
            onTap: onChangePassword,
          ),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          ProfileMenuTile(
            icon: Icons.language,
            title: 'اللغة',
            onTap: () {},
            trailing: const Text(
              'العربية',
              style: TextStyle(
                color: _primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          ProfileMenuTile(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
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
