class RegisterParams {
  final String fullName;
  final String email;
  final String password;

  RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'password': password,
      };
}
