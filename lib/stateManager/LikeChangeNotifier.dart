import 'package:flutter/cupertino.dart';

class LikeChangeNotifier extends ChangeNotifier {
  Map<String, int> _likeMap = {};
  Map<String, int> get likeMap => _likeMap;

  void cleanAndSet(Map<String, int> map) {
    _likeMap = map;
    notifyListeners();
  }

  void addLike(String key, int count) {
    _likeMap[key] = count;
    notifyListeners();
  }

  void changeLike(String key, bool isAdd) {
    int nowLike = _likeMap[key] ?? 0;
    int newLike = isAdd ? nowLike + 1 : nowLike - 1;
    _likeMap[key] = newLike;
    notifyListeners();
  }
}
