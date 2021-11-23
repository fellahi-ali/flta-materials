import 'dart:io' show Platform;

class Env {
  static final edamamKey = Platform.environment['EDAMAM_KEY'] ?? '';
  static final edamamId = Platform.environment['EDAMAM_ID'] ?? '';
}
