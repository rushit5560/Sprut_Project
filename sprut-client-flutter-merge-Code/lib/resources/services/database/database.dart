import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';

class DatabaseService {
  final Logger _log = serviceLocator.get<Logger>();

  SharedPreferences _preferences = serviceLocator.get<SharedPreferences>();

  dynamic getFromDisk(String key) {
    final value = _preferences.get(key);
    return value;
  }

  saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  clearStorage() {
    _preferences.clear();
  }
}
