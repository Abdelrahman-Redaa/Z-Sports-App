import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  const LanguageState(this.locale);

  final Locale locale;

  bool get isEnglish => locale.languageCode == 'en';
  bool get isArabic => locale.languageCode == 'ar';
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState(Locale('ar')));

  static const _languageCodeKey = 'language_code';

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageCodeKey) ?? 'ar';
    emit(LanguageState(Locale(code)));
  }

  Future<void> setLanguage(String code) async {
    final normalizedCode = code == 'en' ? 'en' : 'ar';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, normalizedCode);
    emit(LanguageState(Locale(normalizedCode)));
  }

  Future<void> toggleLanguage() async {
    await setLanguage(state.isEnglish ? 'ar' : 'en');
  }
}

extension LanguageBuildContextX on BuildContext {
  bool get isEnglish => read<LanguageCubit>().state.isEnglish;

  String tr(String ar, String en) {
    return read<LanguageCubit>().state.isEnglish ? en : ar;
  }
}
