import 'package:flutter/foundation.dart';

const _githubStorageUrl = String.fromEnvironment(
  'GITHUB_STORAGE_URL',
  defaultValue:
      'https://raw.githubusercontent.com/ayusuke7/the_makita_verse/storage',
);

class Environment {
  static bool get debugMode => kDebugMode;
  static String get githubStorageUrl => _githubStorageUrl;
}
