import 'package:z_sports_booking/core/network/api_client.dart';
import 'package:z_sports_booking/features/auth/data/repositories/auth_repository.dart';

class DI {
  static final ApiClient apiClient = ApiClient();
  static final AuthRepository authRepository = AuthRepository(apiClient);
}
