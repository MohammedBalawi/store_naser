import 'package:hive/hive.dart';
import 'hive_session_box.dart';

class HiveSessionService {
  static const _sessionBoxName = 'sessionBox';
  static const _authBoxName = 'authBox';
  static const _sessionKey = 'session';
  static const _tokenKey = 'access_token';
  static const _isLoggedInKey = 'isLoggedIn';
  static const _userIdKey = 'user_id';

  Future<void> saveSessionToHive(String accessToken, String userId) async {
    // Save structured session
    final sessionBox = Hive.box<HiveSession>(_sessionBoxName);
    await sessionBox.put(_sessionKey, HiveSession(accessToken: accessToken));

    // Save simple session data
    if (!Hive.isBoxOpen(_authBoxName)) {
      await Hive.openBox(_authBoxName);
    }
    final authBox = Hive.box(_authBoxName);
    await authBox.put(_tokenKey, accessToken);
    await authBox.put(_userIdKey, userId);
    await authBox.put(_isLoggedInKey, true);
  }

  Future<bool> hasSavedSession() async {
    if (!Hive.isBoxOpen(_authBoxName)) {
      await Hive.openBox(_authBoxName);
    }
    final authBox = Hive.box(_authBoxName);
    return authBox.get(_isLoggedInKey, defaultValue: false) == true;
  }

  Future<void> clearSessionFromHive() async {
    if (!Hive.isBoxOpen(_authBoxName)) {
      await Hive.openBox(_authBoxName);
    }
    final authBox = Hive.box(_authBoxName);
    await authBox.delete(_tokenKey);
    await authBox.delete(_isLoggedInKey);
    await authBox.delete(_userIdKey);

    if (Hive.isBoxOpen(_sessionBoxName)) {
      final sessionBox = Hive.box<HiveSession>(_sessionBoxName);
      await sessionBox.delete(_sessionKey);
    }
  }

  HiveSession? getSavedSession() {
    if (!Hive.isBoxOpen(_sessionBoxName)) return null;
    final box = Hive.box<HiveSession>(_sessionBoxName);
    return box.get(_sessionKey);
  }

  String? getSavedUserId() {
    if (!Hive.isBoxOpen(_authBoxName)) return null;
    final authBox = Hive.box(_authBoxName);
    return authBox.get(_userIdKey);
  }
}
