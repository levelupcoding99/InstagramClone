import 'dart:math';

class RandomUUID {
  final _random = Random();
  final _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String getRandomString(int length) {
    return List.generate(
      length,
      (index) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }

  String getReelsId() {
    return '${getRandomString(4)}-${getRandomString(4)}-${getRandomString(4)}';
  }

  String generateNewUserId() {
    return '${getRandomString(5)}-${getRandomString(5)}-${getRandomString(5)}';
  }
}
