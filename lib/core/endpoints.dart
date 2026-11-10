class SyncOperationEndponts {
  static String get syncOperation => '/sync/operation';
}

class LoginEndpoints {
  static String get login => '/user/login';
}

class RegisterEndpoints {
  static String get register => '/user/register';
}

class OtpEndpoints {
  static String get verifyOtp => '/user/register/verify-otp';
  static String get resendOtp => '/user/register/resend-otp';
}

class TaskEndpoints {
  static String get getTasks => '/task';
}
