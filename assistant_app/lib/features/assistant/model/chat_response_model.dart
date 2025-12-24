class ChatResponse {
  final String? answer;
  final String? error;

  ChatResponse({this.answer, this.error});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      answer: json['answer'] as String?, // Adjust based on actual API response key for the message
      error: json['error'] as String?,
    );
  }
}
