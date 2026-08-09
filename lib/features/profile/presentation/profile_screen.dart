import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';

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
  static bool _hasShownPointsDialog = false;

  @override
  void initState() {
    super.initState();
    if (!_hasShownPointsDialog) {
      _hasShownPointsDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCongratulationsDialog(context);
      });
    }
  }

  void _showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: _primary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
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
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF242424),
                      border: Border.all(
                        color: _primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '50',
                          style: TextStyle(
                            color: _primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'نقطة',
                          style: TextStyle(color: _primary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: _primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_border,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'تهانينا!',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تحصل على 50 نقطة مكافأة مقابل حجزك\nالناجح',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'عند وصول 1000 نقطة تحصل على حجز مجاني',
                textAlign: TextAlign.center,
                style: TextStyle(color: _textSecondary, fontSize: 12),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: const Color(0xFF182540),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'متابعة',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: MockData.currentUser.avatarUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              MockData.currentUser.name,
              style: const TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 24,
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
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _StatCard(value: '12', label: 'حجز'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(value: '5', label: 'ملاعب'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(value: '280', label: 'نقطة', showIcon: true),
                ),
              ],
            ),

            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الإعدادات',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),

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
              title: 'اللغة',
              icon: Icons.language,
              trailing: const Text(
                'العربية',
                style: TextStyle(
                  color: _primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => context.go(AppRoutes.welcome),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B2F22)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.w800,
              fontSize: 22,
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.icon,
    this.trailing,
    required this.onTap,
  });

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
      trailing:
          trailing ??
          const Icon(Icons.arrow_back_ios_new, size: 16, color: _textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          color: _textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}
