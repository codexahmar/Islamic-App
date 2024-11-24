import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
      );
}

class ChatService {
  final String apiKey =
      'AIzaSyA9V50rkHxCtmsP1jyjx1MG8MjNKdq62o4'; // Replace with your API key
  static const String _storageKey = 'chat_messages';

  // Voice assistant components
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  ChatService() {
    _initializeTTS();
    _initializeSTT();
  }

  // Initialize Text-to-Speech
  Future<void> _initializeTTS() async {
    try {
      await flutterTts.setLanguage("en-US");

      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      // Set up error handling
      flutterTts.setErrorHandler((msg) {
        print("TTS Error: $msg");
      });
    } catch (e) {
      print("TTS Initialization Error: $e");
    }
  }

  // Initialize Speech-to-Text
  Future<void> _initializeSTT() async {
    if (!_isInitialized) {
      try {
        _isInitialized = await speech.initialize(
          onError: (error) => print('Speech to text error: $error'),
          onStatus: (status) => print('Speech to text status: $status'),
          debugLogging: true,
        );
      } catch (e) {
        print("STT Initialization Error: $e");
        _isInitialized = false;
      }
    }
  }

  // Check and request microphone permission
  Future<bool> checkMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      if (status.isGranted) {
        return true;
      }

      final result = await Permission.microphone.request();
      return result.isGranted;
    } catch (e) {
      print("Permission Error: $e");
      return false;
    }
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Start listening for speech input
  Future<bool> startListening({
    required Function(String) onResult,
    required Function(String) onStatus,
  }) async {
    if (_isListening) {
      return false;
    }

    if (!_isInitialized) {
      await _initializeSTT();
    }

    if (!_isInitialized) {
      return false;
    }

    try {
      _isListening = await speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            _isListening = false;
          }
        },
        // onStatus: (status) {
        //   onStatus(status);
        //   if (status == 'done') {
        //     _isListening = false;
        //   }
        // },
        localeId: 'en_US',

        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );

      return _isListening;
    } catch (e) {
      print("Listen Error: $e");
      _isListening = false;
      return false;
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    if (_isListening) {
      try {
        await speech.stop();
        _isListening = false;
      } catch (e) {
        print("Stop Listening Error: $e");
      }
    }
  }

  // Speak response
  // Future<void> speakResponse(String text) async {
  //   try {
  //     await flutterTts.speak(text);
  //   } catch (e) {
  //     print("Speak Error: $e");
  //   }
  // }

  // // Stop speaking
  // Future<void> stopSpeaking() async {
  //   try {
  //     await flutterTts.stop();
  //   } catch (e) {
  //     print("Stop Speaking Error: $e");
  //   }
  // }

  // Get chat response from API
  Future<String> getChatResponse(String userMessage) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');

    final systemPrompt =
        """You are an Islamic AI assistant designed to answer questions about Islam, 
    Islamic history, Quran, Hadith, and Islamic practices. If the user's question is in Roman Urdu or Urdu, 
    respond in the same language. If the question is in English, respond in English. Ensure that all answers are 
    respectful, authentic, and supported by reliable Islamic sources such as the Quran, Sahih Hadith, and scholarly consensus. 
    Handle critical and sensitive topics, such as marital issues or personal affairs, with empathy and authenticity, citing 
    appropriate Islamic principles. If a question is inappropriate or non-Islamic, politely redirect the conversation 
    to Islamic topics while maintaining respect.

    User Question: $userMessage""";

    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": systemPrompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "maxOutputTokens": 800,
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception(
            'API Error: Status ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to fetch response: $e');
    }
  }

  // Save messages to local storage
  Future<void> saveMessages(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = messages.map((msg) => msg.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(messagesJson));
    } catch (e) {
      print("Save Messages Error: $e");
    }
  }

  // Load messages from local storage
  Future<List<ChatMessage>> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString(_storageKey);
      if (messagesJson == null) return [];

      final List<dynamic> decoded = jsonDecode(messagesJson);
      return decoded.map((msg) => ChatMessage.fromJson(msg)).toList();
    } catch (e) {
      print("Load Messages Error: $e");
      return [];
    }
  }

  // Clear chat history
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print("Clear History Error: $e");
    }
  }
}
