class ApiConstants {
  static const String baseUrl = 'https://generativelanguage.googleapis.com';
  static const String chatEndpoint = '/v1beta/models/gemini-2.5-flash:generateContent';
  static const String apiKey = 'AIzaSyCoGZWs32q-0FzRQpN8XQE__YKkdB_hEzs';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-goog-api-key': apiKey,
  };
}
