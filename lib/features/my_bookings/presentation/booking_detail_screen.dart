import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stadium image
            if (pitchImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: pitchImage,
                  height: 200,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.sports_soccer, size: 80, color: _primary),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.sports_soccer, size: 80, color: _primary),
              ),

            const SizedBox(height: 24),

            // Booking ID badge
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'رقم الحجز: #$bookingId',
                  style: const TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stadium name
            Text(
              pitchName.isNotEmpty ? pitchName : 'ملعب رياضي',
              textAlign: TextAlign.right,
              style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 28),
            ),

            const SizedBox(height: 24),

            // Details card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.calendar_today,
                    label: 'التاريخ',
                    value: date.isNotEmpty ? date : '—',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: _border),
                  ),
                  _DetailRow(
                    icon: Icons.access_time,
                    label: 'الوقت',
                    value: time.isNotEmpty ? time : '—',
                  ),
                  if (price.isNotEmpty && price != '0') ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: _border),
                    ),
                    _DetailRow(
                      icon: Icons.attach_money,
                      label: 'المبلغ المدفوع',
                      value: '$price ج.م',
                      valueColor: _primary,
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: _border),
                  ),
                  _DetailRow(
                    icon: Icons.check_circle_outline,
                    label: 'الحالة',
                    value: 'مؤكد',
                    valueColor: _primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Back button
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: const Text(
                  'العودة للرئيسية',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                onPressed: () {
                  while (context.canPop()) context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: _primary, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = _textPrimary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(color: valueColor, fontWeight: FontWeight.w700, fontSize: 16),
          textAlign: TextAlign.left,
        ),
        Row(
          children: [
            Text(label, style: const TextStyle(color: _textSecondary, fontSize: 14)),
            const SizedBox(width: 8),
            Icon(icon, color: _primary, size: 18),
          ],
        ),
      ],
    );
  }
}
