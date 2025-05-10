import 'dart:math';

String generateOtp({int length = 6}) {
  final random = Random.secure();
  return List.generate(length, (_) => random.nextInt(10)).join();
}
