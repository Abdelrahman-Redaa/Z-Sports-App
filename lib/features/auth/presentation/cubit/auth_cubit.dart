import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_sports_booking/features/auth/data/repositories/auth_repository.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  String _pendingEmail = '';
  String get pendingEmail => _pendingEmail;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.signIn(email, password);
      if (token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        emit(const AuthSuccess());
      } else {
        emit(const AuthError('فشل تسجيل الدخول، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.signUp(name, email, password);
      if (success) {
        _pendingEmail = email;
        emit(const AuthSuccess());
      } else {
        emit(const AuthError('فشل إنشاء الحساب، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> confirmEmail(String email, String otp) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.confirmEmail(email, otp);
      if (success) {
        emit(AuthOtpConfirmed());
      } else {
        emit(const AuthError('رمز التحقق غير صحيح، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> resendEmail(String email) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.resendEmail(email);
      if (success) {
        emit(const AuthSuccess(message: 'تم إعادة إرسال الرمز بنجاح'));
      } else {
        emit(const AuthError('فشل إعادة الإرسال، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> resendResetPasswordOtp(String email) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.forgetPassword(email);
      if (success) {
        _pendingEmail = email;
        emit(const AuthSuccess(message: 'تم إرسال رمز التحقق بنجاح'));
      } else {
        emit(const AuthError('فشل إرسال الرمز، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.forgetPassword(email);
      if (success) {
        _pendingEmail = email;
        emit(const AuthSuccess());
      } else {
        emit(const AuthError('البريد الإلكتروني غير مسجل لدينا.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmNewPassword,
  ) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.resetPassword(
        email,
        otp,
        newPassword,
        confirmNewPassword,
      );
      if (success) {
        emit(const AuthSuccess(message: 'تم تغيير كلمة المرور بنجاح'));
      } else {
        emit(const AuthError('فشل تغيير كلمة المرور، يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _pendingEmail = '';
    emit(AuthInitial());
  }

  void resetState() => emit(AuthInitial());
}
