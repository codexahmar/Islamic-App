import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../UI/Screens/chat_screen.dart';

class ChatService {
  final String apiKey = 'AIzaSyA9V50rkHxCtmsP1jyjx1MG8MjNKdq62o4';
  static const String _storageKey = 'chat_messages';

  Future<String> getChatResponse(String userMessage) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');

    final systemPrompt =
        """You are an Islamic AI assistant that helps answer questions about Islam, 
    Islamic history, Quran, Hadith, and Islamic practices. If the question is in Roman Urdu or Urdu, 
    respond in the same language. Keep responses respectful and cite authentic sources when possible. 
    If the question is inappropriate or non-Islamic, politely redirect to Islamic topics.
    
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
      print('Exception details: $e');
      throw Exception('Failed to fetch response: $e');
    }
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages
        .map((msg) => {
              'text': msg.text,
              'isUser': msg.isUser,
            })
        .toList();
    await prefs.setString(_storageKey, jsonEncode(messagesJson));
  }

  Future<List<ChatMessage>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(_storageKey);
    if (messagesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(messagesJson);
    return decoded
        .map((msg) => ChatMessage(
              text: msg['text'],
              isUser: msg['isUser'],
            ))
        .toList();
  }
}
