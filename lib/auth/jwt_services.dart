import 'dart:collection';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

const _secretKey = 'super_secret'; // Replace with env var in real app

// In-memory blacklist for tokens
final _blacklist = HashSet<String>();

String generateToken(String userId) {
  final jwt = JWT({'userId': userId});
  return jwt.sign(SecretKey(_secretKey), expiresIn: Duration(hours: 1));
}

JWT? verifyToken(String token) {
  // Check if the token is blacklisted
  if (_blacklist.contains(token)) {
    return null; // Token is invalidated
  }

  try {
    return JWT.verify(token, SecretKey(_secretKey));
  } catch (_) {
    return null; // Invalid token
  }
}

void invalidateToken(String token) {
  _blacklist.add(token); // Add token to the blacklist
}
