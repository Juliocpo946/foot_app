class AppLogger {
  static void logError(String module, String message, [dynamic code]) {
    final timestamp = DateTime.now().toString().substring(0, 19);
    final codeStr = code != null ? ' (Code: $code)' : '';
    print('[$timestamp] [$module] [ERROR] $message$codeStr');
  }
}