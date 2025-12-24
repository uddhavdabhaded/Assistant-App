import 'package:assistant_app/features/assistant/repo/assistant_repo.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AssistantController extends GetxController {
  final AssistantRepo _repo = AssistantRepo();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool isListening = false;
  bool isSpeaking = false;
  String spokenText = "";
  String assistantResponse = "How can I help you today?";
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    
    // Attempt to set a female voice
    try {
      List<dynamic> voices = await _flutterTts.getVoices;
      List<dynamic> femaleVoices = voices.where((voice) {
        final name = voice["name"].toString().toLowerCase();
        return name.contains("female");
      }).toList();

      if (femaleVoices.isNotEmpty) {
        await _flutterTts.setVoice({
          "name": femaleVoices.first["name"],
          "locale": femaleVoices.first["locale"]
        });
      }
    } catch (e) {
      print("Error setting female voice: $e");
    }

    _flutterTts.setStartHandler(() {
      isSpeaking = true;
      update(['assistant']);
    });

    _flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      update(['assistant']);
    });

    _flutterTts.setCancelHandler(() {
      isSpeaking = false;
      update(['assistant']);
    });
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    isSpeaking = false;
    update(['assistant']);
    await _flutterTts.stop();
  }

  void listen() async {
    // If AI is speaking, stop it
    if (isSpeaking) {
      await stopSpeaking();
      return; 
    }
    
    // If AI is thinking (loading), cancel it
    if (isLoading) {
      isLoading = false;
      update(['assistant']);
      speak("Cancelled."); // Optional feedback
      return;
    }

    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            isListening = false;
            update(['assistant']);
            
            // If we have recognized text, send it to API
            // Only if NOT manually stopped/cancelled logic could be added, but here we assume silence = submit
            if (spokenText.isNotEmpty && !isLoading) {
              fetchResponse(spokenText);
            }
          }
        },
        onError: (errorNotification) {
          isListening = false;
          update(['assistant']);
          print('Error: $errorNotification');
        },
      );

      if (available) {
        isListening = true;
        spokenText = ""; // Reset previous text
        update(['assistant']);
        
        _speech.listen(
          onResult: (result) {
            spokenText = result.recognizedWords;
            update(['assistant']);
          },
        );
      }
    } else {
      // Manual stop listening (Submit)
      isListening = false;
      _speech.stop();
      update(['assistant']);
    }
  }

  Future<void> fetchResponse(String query) async {
    if (query.trim().isEmpty) return;

    isLoading = true;
    update(['assistant']);

    try {
      final response = await _repo.getChatResponse(query);
      
      // If user cancelled (isLoading set to false manually), don't speak
      if (!isLoading) return;

      assistantResponse = response;
      speak(response); // Speak the response automatically
    } catch (e) {
      // If cancelled, ignore error
      if (!isLoading) return;
      
      assistantResponse = "Sorry, I encountered an error. Please try again.";
      print('API Error: $e');
    } finally {
      isLoading = false;
      update(['assistant']);
    }
  }
}
