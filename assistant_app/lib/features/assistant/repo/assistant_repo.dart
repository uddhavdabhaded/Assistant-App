import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assistant_app/constants/api_constants.dart';

class AssistantRepo {
  Future<String> getChatResponse(String query) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.chatEndpoint}');
      
      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": query
              }
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            (data['candidates'] as List).isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            (data['candidates'][0]['content']['parts'] as List).isNotEmpty) {
              
          final String responseText = data['candidates'][0]['content']['parts'][0]['text'];
          return responseText;
          
        } else {
           return "I'm not sure how to answer that.";
        }
      } else {
        throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching response: $e');
    }
  }
}
