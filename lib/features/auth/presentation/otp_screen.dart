import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 40;
  bool _canResend = false;
  bool get _isRegisterFlow => widget.phone.contains('@');

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsLeft = 40;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpConfirmed) {
          context.go(AppRoutes.home);
        } else if (state is AuthSuccess) {
          if (!_isRegisterFlow) {
            context.push(AppRoutes.resetPassword);
          } else {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: AppColors.primary,
                ),
              );
            }
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.appName),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Text(
                    'تحقق من الرمز',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أدخل الرمز المكون من 4 أرقام المرسل إلى\nبريدك الإلكتروني',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF131114),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (v) => _onChanged(v, index),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),
                  _canResend
                      ? TextButton.icon(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context.read<AuthCubit>().resendEmail(
                                    widget.phone,
                                  );
                                  _startTimer();
                                },
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'إعادة إرسال الرمز',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1C1F),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'إعادة إرسال الرمز خلال ${_formatTime(_secondsLeft)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                  const SizedBox(height: 64),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final otp = _otpCode;
                              if (otp.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('أدخل الرمز كاملاً'),
                                  ),
                                );
                                return;
                              }
                              if (_isRegisterFlow) {
                                context.read<AuthCubit>().confirmEmail(
                                  widget.phone,
                                  otp,
                                );
                              } else {
                                context.push(
                                  '${AppRoutes.resetPassword}?otp=$otp&email=${widget.phone}',
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'تأكيد الرمز',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
