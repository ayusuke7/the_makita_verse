import 'package:flutter/foundation.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseKey = String.fromEnvironment('SUPABASE_KEY');

class Environment {
  static bool get debugMode => kDebugMode;
  static String get supabaseUrl => _supabaseUrl;
  static String get supabaseKey => _supabaseKey;
}
