import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router get protectedRouter {
  final router = Router();

  router.get('/dashboard', (Request request) {
    final userId = request.context['userId'] as String?;
    return Response.ok(jsonEncode({
      'message': 'Welcome to your dashboard!',
      'userId': userId,
    }), headers: {
      'Content-Type': 'application/json',
    });
  });

  return router;
}
