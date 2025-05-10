import 'dart:io';
import 'package:dart_backend/handlers/auth_handlers.dart';
import 'package:dart_backend/handlers/proctected_handlers.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:dart_backend/auth/auth_middleware.dart';
void main() async {
  final router = Router();

  // Public routes
  router.mount('/auth/', authRouter);

  // Protected routes
  final protectedPipeline = Pipeline()
      .addMiddleware(checkAuthorization())
      .addHandler(protectedRouter);
  router.mount('/api/', protectedPipeline);

  // Full pipeline with logging
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server running at http://${server.address.host}:${server.port}');
}
