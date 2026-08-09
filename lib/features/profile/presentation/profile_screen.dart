import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/data/models/user_model.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_state.dart';

const _bg = Color(0xFF182540);
const _surface = Color(0xFF1D2C4D);
const _border = Color(0xFF2A3C60);
const _primary = Color(0xFF39FF14);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF8A96A3);

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
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: _primary));
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, style: const TextStyle(color: _textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().getProfile(),
                    style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.black),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                _buildAvatar(user),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? 'المستخدم',
                  style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 24),
                ),
                const SizedBox(height: 4),
                const Text(
                  'لاعب متميز',
                  style: TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: _StatCard(value: '${user?.bookingsCount ?? 0}', label: 'حجز')),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(value: '${user?.pitchesCount ?? 0}', label: 'ملاعب')),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(value: '${user?.points ?? 0}', label: 'نقطة', showIcon: true)),
                  ],
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
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _primary, width: 2),
        boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.15), blurRadius: 30, spreadRadius: 5)],
      ),
      child: ClipOval(
        child: user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: user.profilePictureUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.person, color: _primary, size: 60),
              )
            : const Icon(Icons.person, color: _primary, size: 60),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, this.showIcon = false});

  final String value;
  final String label;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B2F22)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 22)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: _textSecondary, fontSize: 14)),
          if (showIcon) ...[
            const SizedBox(height: 8),
            const Icon(Icons.monetization_on_outlined, color: Colors.amber, size: 20),
          ],
        ],
      ),
    );
  }
}
