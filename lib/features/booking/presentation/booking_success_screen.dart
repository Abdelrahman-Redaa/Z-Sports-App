import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF182540),
      appBar: AppBar(
        backgroundColor: const Color(0xFF182540),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تأكيد الحجز',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () {
            while (context.canPop()) {
              context.pop();
            }
            context.go(AppRoutes.home);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF39FF14).withValues(alpha: 0.3),
                          blurRadius: 60,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF39FF14),
                        width: 2.5,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF39FF14),
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),
            const Text(
              'تم تأكيد الحجز بنجاح',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 26,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'استعد لتجربة رياضية مميزة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A96A3), fontSize: 15),
            ),

            const SizedBox(height: 48),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تفاصيل الحجز',
                style: TextStyle(
                  color: Color(0xFF39FF14),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1D2C4D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A3C60)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'سلة الحريف',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'الملعب',
                        style: TextStyle(
                          color: Color(0xFF8A96A3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Color(0xFF2A3C60)),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'اليوم، 08:00 مساءً',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'التاريخ والوقت',
                        style: TextStyle(
                          color: Color(0xFF8A96A3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
            SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  while (context.canPop()) {
                    context.pop();
                  }
                  context.go(AppRoutes.home);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF39FF14), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'العودة للرئيسية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
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
