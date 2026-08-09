import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Colors ───
const _bg = Color(0xFF182540);
const _surface = Color(0xFF1D2C4D);
const _border = Color(0xFF2A3C60);
const _primary = Color(0xFF39FF14);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF8A96A3);

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({
    super.key,
    required this.pitchName,
    required this.pitchImage,
    required this.date,
    required this.time,
    required this.price,
    required this.bookingId,
  });

  final String pitchName;
  final String pitchImage;
  final String date;
  final String time;
  final String price;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: _textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: _textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Pitch Image with name overlay ───
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: pitchImage,
                    fit: BoxFit.cover,
                  ),
                ),
                // Dark gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)],
                      ),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2E1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _primary.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'مؤكد',
                      style: TextStyle(
                        color: _primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Pitch name
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 80,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 80),
                      child: Text(
                        pitchName,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // ─── Booking ID & Cost ───
                  Row(
                    children: [
                      // Cost
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'التكلفة',
                                style: TextStyle(color: _textSecondary, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$price ج.م',
                                style: const TextStyle(
                                  color: _primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Booking ID
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'رقم الحجز',
                                style: TextStyle(color: _textSecondary, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '#$bookingId',
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── Date Row ───
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'التاريخ',
                              style: TextStyle(color: _textSecondary, fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _bg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _border),
                              ),
                              child: const Icon(Icons.calendar_today, color: _primary, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ─── Time Row ───
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'الوقت',
                              style: TextStyle(color: _textSecondary, fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _bg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _border),
                              ),
                              child: const Icon(Icons.access_time, color: _primary, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── Cancel Button ───
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 20),
                      label: const Text(
                        'إلغاء الحجز',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => _showCancelDialog(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF3A2020), width: 1),
                        backgroundColor: const Color(0xFF1E1515),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Cancel Policy Note ───
                  const Text(
                    'تطبق سياسة الإلغاء. الإلغاء بعد مرور 24 ساعة من تاريخ الحجز أكثر من ثلاث مرات قد يعرضك لرسوم إضافية للحجز مرة أخرى.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'إلغاء الحجز',
          textAlign: TextAlign.right,
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'هل أنت متأكد من إلغاء الحجز؟',
          textAlign: TextAlign.right,
          style: TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('لا', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('نعم، إلغاء'),
          ),
        ],
      ),
    );
  }
}
