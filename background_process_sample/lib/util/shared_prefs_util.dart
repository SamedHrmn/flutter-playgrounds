import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  static final SharedPrefsUtil _instance = SharedPrefsUtil._();
  SharedPreferences? _shared;

  static const String _counterSharedKey = 'counter';
  static const String _isDetachedSharedKey = 'isDetached';

  SharedPrefsUtil._();

  factory SharedPrefsUtil() => _instance;

  Future<SharedPreferences> init() async {
    if (_shared != null) return _shared!;
    _shared = await SharedPreferences.getInstance();
    return _shared!;
  }

  Future<void> _setInt(String key, int value) async {
    if (_shared == null) return;
    await _shared!.setInt(key, value);
  }

  Future<int?> _getInt(String key) async {
    if (_shared == null) return null;

    await _shared!.reload();
    return _shared!.getInt(key);
  }

  Future<void> _setBool(String key, bool value) async {
    if (_shared == null) return;

    await _shared!.setBool(key, value);
  }

  Future<bool?> _getBool(String key) async {
    if (_shared == null) return null;

    await _shared!.reload();
    return _shared!.getBool(key);
  }

  Future<int?> getCounter() async {
    return _getInt(_counterSharedKey);
  }

  Future<bool?> getIsDetached() async {
    return _getBool(_isDetachedSharedKey);
  }

  Future<void> setCounter(int value) async {
    await _setInt(_counterSharedKey, value);
  }

  Future<void> setIsDetached(bool value) async {
    await _setBool(_isDetachedSharedKey, value);
  }
}
