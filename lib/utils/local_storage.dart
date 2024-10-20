import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static late FlutterSecureStorage storage;

  static void initStorage() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          // encryptedSharedPreferences: true,
        );
     storage = FlutterSecureStorage();
  }
}
