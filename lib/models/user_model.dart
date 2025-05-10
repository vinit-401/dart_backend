class User {
  final String id;
  final String email;
  String passwordHash;
  bool isVerified;
  String? otpCode;
  DateTime? otpExpiresAt;

  User({
    required this.id,
    required this.email,
    required this.passwordHash,
    this.isVerified = false,
    this.otpCode,
    this.otpExpiresAt,
  });
}
