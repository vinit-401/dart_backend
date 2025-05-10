// In lib/handlers/auth_handler.dart

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../auth/jwt_services.dart';
import '../auth/otp_services.dart';
import '../services/user_services.dart';
import '../utils/email_sender.dart';
import '../utils/response_handlers.dart';


final _userService = UserService();

Router get authRouter {
  final router = Router();

  // POST /auth/signup
  router.post('/signup', (Request request) async {
    final body = jsonDecode(await request.readAsString());
    final email = body['email'];
    final password = body['password'];

    if (email == null || password == null) {
      return errorResponse('Email and password are required.');
    }

    try {
      final user = _userService.createUser(email, password);
      final otp = generateOtp();
      _userService.setOtp(user, otp, Duration(minutes: 10));
      sendOtpToEmail(user.email, otp);

      return jsonResponse({'message': 'User created. OTP sent to email.'});
    } catch (e) {
      return errorResponse(e.toString());
    }
  });

  // POST /auth/verify
  router.post('/verify', (Request request) async {
    final body = jsonDecode(await request.readAsString());
    final email = body['email'];
    final otp = body['otp'];

    final user = _userService.findByEmail(email);
    if (user == null) {
      return errorResponse('User not found.');
    }

    if (_userService.verifyOtp(user, otp)) {
      return jsonResponse({'message': 'Email verified successfully.'});
    } else {
      return errorResponse('Invalid or expired OTP.');
    }
  });

  // POST /auth/signin
  router.post('/signin', (Request request) async {
    final body = jsonDecode(await request.readAsString());
    final email = body['email'];
    final password = body['password'];

    final user = _userService.findByEmail(email);
    if (user == null || !_userService.verifyPassword(user, password)) {
      return errorResponse('Invalid credentials.', statusCode: 401);
    }

    if (!user.isVerified) {
      return errorResponse('Email not verified.', statusCode: 403);
    }

    final token = generateToken(user.id);
    return jsonResponse({'token': token});
  });

  // POST /auth/logout (Add logout functionality)
  router.post('/logout', (Request request) async {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return errorResponse('Missing or invalid Authorization header.');
    }

    final token = authHeader.substring(7); // Get token from "Bearer <token>"
    invalidateToken(token); // Add the token to the blacklist

    return jsonResponse({'message': 'Logged out successfully.'});
  });

  // POST /auth/forgot-password
  router.post('/forgot-password', (Request request) async {
    final body = jsonDecode(await request.readAsString());
    final email = body['email'];

    final user = _userService.findByEmail(email);
    if (user == null) {
      return errorResponse('User not found.');
    }

    final otp = generateOtp();
    _userService.setOtp(user, otp, Duration(minutes: 10));
    sendOtpToEmail(user.email, otp);

    return jsonResponse({'message': 'OTP sent to email for password reset.'});
  });

  // POST /auth/reset-password
  router.post('/reset-password', (Request request) async {
    final body = jsonDecode(await request.readAsString());
    final email = body['email'];
    final otp = body['otp'];
    final newPassword = body['newPassword'];

    final success = _userService.resetPassword(email, otp, newPassword);
    if (success) {
      return jsonResponse({'message': 'Password reset successful.'});
    } else {
      return errorResponse('Invalid OTP or expired.');
    }
  });

  return router;
}
