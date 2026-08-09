import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/features/profile/data/repositories/profile_repository.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final user = await _repository.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    final current = state;
    if (current is ProfileLoaded) {
      emit(ProfileUpdating(current.user));
    }
    try {
      final updated = await _repository.updateProfile(
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
      emit(ProfileUpdateSuccess(updated, 'تم تحديث الملف الشخصي بنجاح'));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateAvatar(File imageFile) async {
    final current = state;
    if (current is ProfileLoaded) {
      emit(ProfileUpdating(current.user));
    }
    try {
      await _repository.updateAvatar(imageFile);
      final updated = await _repository.getProfile();
      emit(ProfileUpdateSuccess(updated, 'تم تحديث الصورة الشخصية بنجاح'));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final current = state;
    if (current is ProfileLoaded) {
      emit(ProfileUpdating(current.user));
    }
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      if (current is ProfileLoaded) {
        emit(ProfileUpdateSuccess(current.user, 'تم تغيير كلمة المرور بنجاح'));
      }
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
