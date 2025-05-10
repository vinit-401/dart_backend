import 'package:shelf/shelf.dart';
import 'jwt_services.dart';

Middleware checkAuthorization() {
  return (Handler handler) {
    return (Request request) async {
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden('Missing or invalid Authorization header.');
      }

      final token = authHeader.substring(7);
      final jwt = verifyToken(token);
      if (jwt == null) {
        return Response.forbidden('Invalid or expired token.');
      }

      final updatedRequest = request.change(context: {'userId': jwt.payload['userId']});
      return handler(updatedRequest);
    };
  };
}
