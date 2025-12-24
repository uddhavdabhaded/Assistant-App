class ApiConstants {
  static const String baseUrl = 'https://generativelanguage.googleapis.com';
  static const String chatEndpoint = '/v1beta/models/gemini-2.5-flash:generateContent';
  static const String apiKey = 'AIzaSyAf7n9hAp342_4-M9bY7E3LQCfOmrvS21U';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-goog-api-key': apiKey,
  };
}
