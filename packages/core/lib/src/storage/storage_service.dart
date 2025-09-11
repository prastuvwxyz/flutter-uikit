/// Storage service for web and mobile platforms
abstract class StorageService {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
  Future<void> clear();
}

/// Web storage implementation using localStorage
class WebStorageService implements StorageService {
  @override
  Future<String?> getString(String key) async {
    // TODO: Implement web storage
    return null;
  }

  @override
  Future<void> setString(String key, String value) async {
    // TODO: Implement web storage
  }

  @override
  Future<void> remove(String key) async {
    // TODO: Implement web storage
  }

  @override
  Future<void> clear() async {
    // TODO: Implement web storage
  }
}
