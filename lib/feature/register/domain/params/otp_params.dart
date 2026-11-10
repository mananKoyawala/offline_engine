class VerifyOtpParams {
  final String email;
  final String otp;

  VerifyOtpParams({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

class ResendOtpParams {
  final String email;

  ResendOtpParams({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
