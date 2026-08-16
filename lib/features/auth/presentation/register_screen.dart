import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/router/navigation_helper.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/core/widgets/labeled_field.dart';
import 'package:z_sports_booking/core/widgets/primary_button.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          final email = Uri.encodeComponent(_emailController.text.trim());
          context.push('${AppRoutes.otp}?phone=$email&flow=register');
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => popOrGo(context, AppRoutes.welcome),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('انضم إلى Z Sports', 'Join Z Sports'),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr(
                        'سجل الآن لحجز ملاعبك المفضلة بسهولة',
                        'Create an account to book your favorite fields easily',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    DarkLabeledField(
                      controller: _nameController,
                      label: context.tr('الاسم', 'Name'),
                      hint: context.tr('أدخل اسمك الكامل', 'Enter your name'),
                      prefixIcon: Icons.person_outline,
                      validator: (v) => v == null || v.isEmpty
                          ? context.tr('أدخل الاسم', 'Enter name')
                          : null,
                    ),
                    const SizedBox(height: 18),
                    DarkLabeledField(
                      controller: _emailController,
                      label: context.tr('البريد الإلكتروني', 'Email'),
                      hint: 'example@mail.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (v) => v == null || v.isEmpty
                          ? context.tr('أدخل البريد', 'Enter email')
                          : null,
                    ),
                    const SizedBox(height: 18),
                    DarkLabeledField(
                      controller: _passwordController,
                      label: context.tr('كلمة المرور', 'Password'),
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? context.tr('6 أحرف على الأقل', 'At least 6 chars')
                          : null,
                    ),
                    const SizedBox(height: 18),
                    DarkLabeledField(
                      label: context.tr(
                        'تأكيد كلمة المرور',
                        'Confirm Password',
                      ),
                      hint: '••••••••',
                      obscureText: _obscureConfirm,
                      prefixIcon: Icons.lock_reset,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) => v != _passwordController.text
                          ? context.tr(
                              'كلمة المرور غير متطابقة',
                              'Passwords do not match',
                            )
                          : null,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: context.tr('إنشاء حساب', 'Create Account'),
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr(
                            'لديك حساب بالفعل؟',
                            'Already have an account?',
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => popOrGo(context, AppRoutes.login),
                          child: Text(
                            context.tr('تسجيل الدخول', 'Login'),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
