import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
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
  bool _hasSpecialChar = false;

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      final val = _newPasswordController.text;
      setState(() {
        _has8Chars = val.length >= 8;
        _hasUpperCase = val.contains(RegExp(r'[A-Z]'));
        _hasSpecialChar = val.contains(RegExp(r'[@#\$!%*?&]'));
      });
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _allRequirementsMet =>
      _has8Chars && _hasUpperCase && _hasSpecialChar;

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
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'تعيين كلمة مرور جديدة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'قم بإنشاء كلمة مرور قوية لحماية حسابك من خلال الخطوات التالية.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'كلمة المرور',
                      style: TextStyle(
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
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تأكيد كلمة المرور',
                      style: TextStyle(
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
                          label: 'على الأقل 8 أحرف',
                        ),
                        const SizedBox(height: 12),
                        _RequirementRow(
                          met: _hasUpperCase,
                          label: 'حرف كبير واحد على الأقل',
                        ),
                        const SizedBox(height: 12),
                        _RequirementRow(
                          met: _hasSpecialChar,
                          label: r'رمز خاص (مثل @, #, $)',
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
                                  const SnackBar(
                                    content: Text(
                                      'كلمة المرور لا تستوفي المتطلبات',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (_newPasswordController.text !=
                                  _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('كلمتا المرور غير متطابقتين'),
                                  ),
                                );
                                return;
                              }
                              final email =
                                  widget.email ??
                                  context.read<AuthCubit>().pendingEmail;
                              final otp = widget.otp ?? '';
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
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_reset, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'حفظ وتغيير',
                                  style: TextStyle(
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
