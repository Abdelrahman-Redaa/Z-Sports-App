import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';

const _bgColor = Color(0xFF182540);
const _surfaceColor = Color(0xFF1D2C4D);
const _borderColor = Color(0xFF2A3C60);
const _primaryColor = Color(0xFF39FF14);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF8A96A3);

class BookingCheckoutScreen extends StatefulWidget {
  const BookingCheckoutScreen({
    super.key,
    required this.pitchId,
    required this.date,
    required this.time,
  });

  final String pitchId;
  final String date;
  final String time;

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
  int _selectedPayment = 0;
  static const _instapayNumber = '01012345678';

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${parsed.day} ${months[parsed.month]} ${parsed.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pitch = MockData.pitchById(widget.pitchId);
    final formattedDate = _formatDate(widget.date);
    final displayTime = widget.time.isNotEmpty ? widget.time : '08:00 م';
    final timeRange = '$displayTime - 09:00 م';

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إتمام الدفع',
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: _textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ملخص الحجز',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 130,
                    child: CachedNetworkImage(
                      imageUrl: pitch.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pitch.category,
                            style: const TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pitch.name,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.calendar_today,
                                size: 13,
                                color: _textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                timeRange,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.access_time,
                                size: 13,
                                color: _textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'طريقة الدفع',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _PaymentOption(
              icon: Icons.credit_card,
              title: 'انستا باي',
              subtitle: 'دفع سريع وآمن بلمسة واحدة',
              isSelected: _selectedPayment == 0,
              onTap: () => setState(() => _selectedPayment = 0),
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              icon: Icons.payments_outlined,
              title: 'الدفع عند اللعب',
              isSelected: _selectedPayment == 1,
              onTap: () => setState(() => _selectedPayment = 1),
            ),
            const SizedBox(height: 24),
            if (_selectedPayment == 0) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: _instapayNumber),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ رقم التحويل'),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 18,
                            color: _primaryColor,
                          ),
                        ),
                        const Text(
                          'رقم التحويل',
                          style: TextStyle(color: _textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _instapayNumber,
                        style: TextStyle(
                          color: _textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: _borderColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${pitch.pricePerHour.toInt()} ج.م',
                          style: const TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const Text(
                          'المجموع الكلي',
                          style: TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1719),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF382023)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color(0xFFD66A65),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ارسل صورة التحويل على واتساب على نفس رقم التحويل لتأكيد الحجز فوراً.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFFD66A65),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${pitch.pricePerHour.toInt()} ج.م',
                          style: const TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'قيمة الحجز',
                          style: TextStyle(color: _textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: _borderColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${pitch.pricePerHour.toInt()} ج.م',
                          style: const TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const Text(
                          'المجموع الكلي',
                          style: TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        color: _bgColor,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline, size: 22),
            label: const Text(
              'تأكيد الحجز',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            onPressed: () => context.push(AppRoutes.bookingSuccess),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: _bgColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _primaryColor : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _primaryColor : _textSecondary,
                  width: 1.5,
                ),
                color: isSelected ? _primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 10, color: Colors.white)
                  : null,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 16),
            Icon(icon, color: _primaryColor, size: 28),
          ],
        ),
      ),
    );
  }
}
