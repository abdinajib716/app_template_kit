abstract final class AppEnvironment {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://sombook.mrk.so',
  );

  static const apiConnectTimeout = Duration(seconds: 20);
  static const apiReceiveTimeout = Duration(seconds: 30);
}
