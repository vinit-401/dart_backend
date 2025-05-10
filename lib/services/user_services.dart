import 'dart:collection';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class UserService {
  final Map<String, User> _users = HashMap();
  final _uuid = Uuid();

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Updated findByEmail function to handle null correctly
  User? findByEmail(String email) {
    try {
      // Use firstWhere and throw an exception if not found
      return _users.values.firstWhere(
            (user) => user.email == email,
      );
    } catch (e) {
      return null; // Return null if no user is found
    }
  }

  User createUser(String email, String password) {
    final existing = findByEmail(email);
    if (existing != null) {
      throw Exception('User already exists');
    }

    final id = _uuid.v4();
    final passwordHash = _hashPassword(password);
    final user = User(id: id, email: email, passwordHash: passwordHash);
    _users[id] = user;
    return user;
  }

  bool verifyPassword(User user, String password) {
    return user.passwordHash == _hashPassword(password);
  }

  void setOtp(User user, String otpCode, Duration expiresIn) {
    user.otpCode = otpCode;
    user.otpExpiresAt = DateTime.now().add(expiresIn);
  }

  bool verifyOtp(User user, String otp) {
    if (user.otpCode == otp && DateTime.now().isBefore(user.otpExpiresAt!)) {
      user.isVerified = true;
      user.otpCode = null;
      user.otpExpiresAt = null;
      return true;
    }
    return false;
  }

  bool resetPassword(String email, String otp, String newPassword) {
    final user = findByEmail(email);
    if (user == null || user.otpCode != otp || DateTime.now().isAfter(user.otpExpiresAt!)) {
      return false;
    }
    user.passwordHash = _hashPassword(newPassword);
    user.otpCode = null;
    user.otpExpiresAt = null;
    return true;
  }
}
