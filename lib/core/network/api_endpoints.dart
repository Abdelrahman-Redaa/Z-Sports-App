class ApiEndpoints {
  static const String baseUrl = 'https://zsports.runasp.net';

  // Account
  static const String signUp = '/Api/Account/SignUp';
  static const String signIn = '/Api/Account/SignIn';
  static const String confirmEmail = '/Api/Account/ConfirmEmail';
  static const String resendEmail = '/Api/Account/ResendEmail';
  static const String forgetPassword = '/Api/Account/ForgetPassword';
  static const String resetPassword = '/Api/Account/ResetPasword'; // Note the typo in endpoint based on Postman

  // Bookings
  static const String bookings = '/api/Bookings';
  static const String myBookings = '/api/Bookings/my';
  
  static String stadiumSlots(int id) => '/api/Bookings/slots/$id';
  static String bookingById(int id) => '/api/Bookings/$id';

  // Categories
  static const String categories = '/api/Categories';

  // Favorites
  static const String getFavorites = '/api/Favorites';
  static String toggleFavorite(int id) => '/api/Favorites/$id';

  // Profile
  static const String getProfile = '/api/account/me';
  static const String changePassword = '/api/account/me/change-password';
  static const String setAvatar = '/api/account/me/avatar';

  // Stadiums
  static const String getAllStadiums = '/api/Stadiums/all';
  static const String searchStadiums = '/api/Stadiums'; // + ?CategoryId=...
  static String stadiumById(int id) => '/api/Stadiums/$id';
}
