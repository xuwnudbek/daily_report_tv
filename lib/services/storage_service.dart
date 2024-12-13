import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  // Save data to storage
  static Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Read data from storage
  static T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Remove data from storage
  static Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data from storage
  static Future<void> clearStorage() async {
    await _storage.erase();
  }
}
