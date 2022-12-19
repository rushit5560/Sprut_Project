import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static Future<String> fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(minutes: 2),
        minimumFetchInterval: Duration(seconds: 1),
      ),
    );

    await remoteConfig.fetchAndActivate();
    return remoteConfig.getString("testPhones");
  }
}
