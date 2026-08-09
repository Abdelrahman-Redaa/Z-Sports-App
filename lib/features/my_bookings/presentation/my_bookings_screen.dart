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

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'مرحباً، ${MockData.currentUser.name.split(' ').first}',
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        'Z Sports Booking',
                        style: TextStyle(
                          color: _primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      MockData.currentUser.avatarUrl,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'حجوزاتي',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'إدارة نشاطاتك الرياضية القادمة',
                textAlign: TextAlign.right,
                style: TextStyle(color: _textSecondary, fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _BookingCard(
                    pitchName: 'سلة الحريف',
                    pitchCategory: 'Z Sports ملاعب',
                    date: '15 أكتوبر',
                    time: '08:00 م',
                    icon: Icons.sports_basketball,
                    onTap: () => context.push(
                      AppRoutes.bookingDetail,
                      extra: {
                        'pitchName': 'سلة الحريف',
                        'pitchImage': MockData.pitches[5].imageUrl,
                        'date': 'الأربعاء، 15 أكتوبر 2026',
                        'time': '8:00 م - 9:00 م (60 دقيقة)',
                        'price': '280',
                        'bookingId': 'A-1',
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _BookingCard(
                    pitchName: 'ملعب الملوك',
                    pitchCategory: 'Z Sports ملاعب',
                    date: '18 أكتوبر',
                    time: '10:30 م',
                    icon: Icons.sports_soccer,
                    onTap: () => context.push(
                      AppRoutes.bookingDetail,
                      extra: {
                        'pitchName': 'ملعب الملوك',
                        'pitchImage': MockData.pitches[1].imageUrl,
                        'date': 'الأربعاء، 18 أكتوبر 2026',
                        'time': '10:30 م - 11:30 م (60 دقيقة)',
                        'price': '250',
                        'bookingId': 'A-2',
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.pitchName,
    required this.pitchCategory,
    required this.date,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  final String pitchName;
  final String pitchCategory;
  final String date;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _primary, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2E1A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'مؤكد',
                  style: TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pitchName,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pitchCategory,
                    style: const TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _surface,
                ),
                child: Icon(icon, color: _primary, size: 26),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.access_time, color: _primary, size: 18),
              const SizedBox(width: 20),
              Text(
                date,
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.calendar_today, color: _primary, size: 18),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: _bg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'عرض تفاصيل الحجز',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
