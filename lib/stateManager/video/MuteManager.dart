class MuteManager {
  static final MuteManager _instance = MuteManager._internal();
  static MuteManager get instance => _instance;

  bool isMute = false;
  MuteManager._internal();
}
