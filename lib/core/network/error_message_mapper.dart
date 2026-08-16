import 'package:dio/dio.dart';

String friendlyDioError(DioException error, {String? fallbackMessage}) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return 'الاتصال بطيء، حاول مرة أخرى بعد قليل.';
  }

  if (error.type == DioExceptionType.connectionError ||
      (error.type == DioExceptionType.unknown && error.response == null)) {
    return 'لا يوجد اتصال بالإنترنت، تأكد من الشبكة وحاول مرة أخرى.';
  }

  final response = error.response;
  if (response == null) {
    return fallbackMessage ?? 'حدث خطأ غير متوقع، حاول مرة أخرى.';
  }

  final extracted = _extractServerMessage(response.data);
  final normalized = _normalizeMessage(
    extracted,
    statusCode: response.statusCode,
    fallbackMessage: fallbackMessage,
  );

  return normalized;
}

String _extractServerMessage(dynamic data) {
  if (data is String) return data;

  if (data is Map) {
    for (final key in [
      'message',
      'Message',
      'error',
      'Error',
      'title',
      'Title',
    ]) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    final errors = data['errors'] ?? data['Errors'];
    if (errors is Map && errors.isNotEmpty) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }
  }

  return '';
}

String _normalizeMessage(
  String raw, {
  required int? statusCode,
  String? fallbackMessage,
}) {
  final message = raw.trim();
  final lower = message.toLowerCase();

  if (lower.contains('played') ||
      lower.contains('already played') ||
      lower.contains('has been played') ||
      lower.contains('past') ||
      lower.contains('expired') ||
      lower.contains('passed') ||
      lower.contains('finished') ||
      lower.contains('completed') ||
      lower.contains('time has passed') ||
      lower.contains('date has passed') ||
      lower.contains('موعده فات') ||
      lower.contains('اتلعب') ||
      lower.contains('انتهى') ||
      lower.contains('منتهي')) {
    return 'لا يمكن إلغاء حجز اتلعب أو موعده فات.';
  }

  if (lower.contains('can not cancel') ||
      lower.contains('cannot cancel') ||
      lower.contains("can't cancel") ||
      lower.contains('cancel booking') ||
      lower.contains('cancel reservation') ||
      lower.contains('24 hour') ||
      lower.contains('24h') ||
      lower.contains('24 ساعة')) {
    return 'لا يمكن إلغاء الحجز قبل موعده بأقل من 24 ساعة.';
  }

  if (lower.contains('unauthorized') || statusCode == 401) {
    return 'انتهت صلاحية الجلسة، سجل الدخول مرة أخرى.';
  }

  if (lower.contains('forbidden') || statusCode == 403) {
    return 'ليس لديك صلاحية لتنفيذ هذا الإجراء.';
  }

  if (lower.contains('not found') || statusCode == 404) {
    return 'البيانات المطلوبة غير موجودة.';
  }

  if (lower.contains('already booked') ||
      lower.contains('not available') ||
      lower.contains('slot')) {
    return 'هذا الموعد غير متاح، اختر موعدًا آخر.';
  }

  if (lower.contains('otp') ||
      lower.contains('code') ||
      lower.contains('token') ||
      lower.contains('verification')) {
    return 'رمز التحقق غير صحيح، يرجى المحاولة مرة أخرى.';
  }

  if (lower.contains('password')) {
    return 'تأكد من كلمة المرور وحاول مرة أخرى.';
  }

  if (lower.contains('email')) {
    return 'تأكد من البريد الإلكتروني وحاول مرة أخرى.';
  }

  if (message.isNotEmpty && !_looksTechnical(message)) return message;

  if (statusCode != null && statusCode >= 500) {
    return 'حدث خطأ في الخادم، حاول مرة أخرى لاحقًا.';
  }

  return fallbackMessage ?? 'حدث خطأ، حاول مرة أخرى.';
}

bool _looksTechnical(String message) {
  final lower = message.toLowerCase();
  return lower.contains('exception') ||
      lower.contains('dioexception') ||
      lower.contains('status code') ||
      lower.contains('{') ||
      lower.contains('}');
}
