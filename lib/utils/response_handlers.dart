import 'dart:convert';
import 'package:shelf/shelf.dart';

Response jsonResponse(Map<String, dynamic> data, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: json.encode(data),
    headers: {'Content-Type': 'application/json'},
  );
}

Response errorResponse(String message, {int statusCode = 400}) {
  return jsonResponse({'error': message}, statusCode: statusCode);
}
