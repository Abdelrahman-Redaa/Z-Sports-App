import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';

const _bg = Color(0xFF182540);
const _border = Color(0xFF2A3C60);
const _primary = Color(0xFF39FF14);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF8A96A3);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          'الإعدادات',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _SettingsTile(
              title: 'تعديل الملف الشخصي',
              icon: Icons.person_outline,
              onTap: () => context.push(AppRoutes.editProfile),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(color: _border),
            ),
            _SettingsTile(
              title: 'تغيير كلمة المرور',
              icon: Icons.lock_outline,
              onTap: () => context.push(AppRoutes.changePassword),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(color: _border),
            ),
            _SettingsTile(
              title: 'اللغة',
              icon: Icons.language,
              trailing: const Text(
                'العربية',
                style: TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 16),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD66A65),
                  side: const BorderSide(color: Color(0xFF382023)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.go(AppRoutes.welcome);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 22),
                    SizedBox(width: 12),
                    Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.icon, this.trailing, required this.onTap});

  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Icon(icon, color: _primary, size: 28),
      trailing: trailing ?? const Icon(Icons.arrow_back_ios_new, size: 16, color: _textSecondary),
      title: Text(
        title,
        style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
