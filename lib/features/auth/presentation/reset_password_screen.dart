import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.email, this.otp});

  final String? email;
  final String? otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _has8Chars = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  late final TextEditingController _otpController;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController(text: widget.otp ?? '');
    _newPasswordController.addListener(() {
      final val = _newPasswordController.text;
      setState(() {
        _has8Chars = val.length >= 8;
        _hasUpperCase = val.codeUnits.any((c) => c >= 65 && c <= 90);
        _hasLowerCase = val.codeUnits.any((c) => c >= 97 && c <= 122);
        _hasDigit = val.codeUnits.any((c) => c >= 48 && c <= 57);
        _hasSpecialChar = '@#\$!%*?&'.split('').any(val.contains);
      });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _allRequirementsMet =>
      _has8Chars &&
      _hasUpperCase &&
      _hasLowerCase &&
      _hasDigit &&
      _hasSpecialChar;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(AppRoutes.login);
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
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: const Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.go(AppRoutes.login),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr('تعيين كلمة مرور جديدة', 'Set a New Password'),
                    textAlign: context.isEnglish
                        ? TextAlign.left
                        : TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tr(
                      'قم بإنشاء كلمة مرور قوية لحماية حسابك من خلال الخطوات التالية.',
                      'Create a strong password to protect your account.',
                    ),
                    textAlign: context.isEnglish
                        ? TextAlign.left
                        : TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: context.isEnglish
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      context.tr('رمز التحقق', 'Verification Code'),
                      style: const TextStyle(
                        color: AppColors.textLabel,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _otpController,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 6,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '0000',
                      hintStyle: const TextStyle(
                        color: AppColors.textMuted,
                        letterSpacing: 6,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.surfaceBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: context.isEnglish
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      context.tr('كلمة المرور', 'Password'),
                      style: const TextStyle(
                        color: AppColors.textLabel,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    obscure: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: context.isEnglish
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      context.tr('تأكيد كلمة المرور', 'Confirm Password'),
                      style: const TextStyle(
                        color: AppColors.textLabel,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Column(
                      children: [
                        _RequirementRow(
                          met: _has8Chars,
                          label: context.tr(
                            'على الأقل 8 أحرف',
                            'At least 8 characters',
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RequirementRow(
                          met: _hasUpperCase,
                          label: context.tr(
                            'حرف كبير واحد على الأقل',
                            'At least one uppercase letter',
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RequirementRow(
                          met: _hasLowerCase,
                          label: context.tr(
                            'حرف صغير واحد على الأقل',
                            'At least one lowercase letter',
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RequirementRow(
                          met: _hasDigit,
                          label: context.tr(
                            'رقم واحد على الأقل',
                            'At least one number',
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RequirementRow(
                          met: _hasSpecialChar,
                          label: context.tr(
                            r'رمز خاص (مثل @, #, $)',
                            r'Special character (e.g. @, #, $)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (!_allRequirementsMet) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr(
                                        'كلمة المرور لا تستوفي المتطلبات',
                                        'Password does not meet requirements',
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (_newPasswordController.text !=
                                  _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr(
                                        'كلمتا المرور غير متطابقتين',
                                        'Passwords do not match',
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }
                              final email =
                                  widget.email ??
                                  context.read<AuthCubit>().pendingEmail;
                              final otp = _otpController.text.trim();
                              if (email.trim().isEmpty || otp.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr(
                                        'رمز التحقق غير صحيح، اطلب رمزاً جديداً.',
                                        'Invalid verification code. Request a new code.',
                                      ),
                                    ),
                                  ),
                                );
                                context.go(AppRoutes.forgotPassword);
                                return;
                              }
                              if (otp.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr(
                                        'أدخل رمز التحقق كاملاً',
                                        'Enter the full verification code',
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }
                              context.read<AuthCubit>().resetPassword(
                                email,
                                otp,
                                _newPasswordController.text,
                                _confirmPasswordController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.textPrimary,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_reset, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  context.tr('حفظ وتغيير', 'Save Changes'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                hintText: '••••••••',
                hintStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.lock_outline, color: AppColors.primary, size: 22),
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.met, required this.label});

  final bool met;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: met ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.check_circle,
          size: 20,
          color: met ? AppColors.primary : AppColors.surfaceBorder,
        ),
      ],
    );
  }
}
