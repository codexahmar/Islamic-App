import 'package:flutter/material.dart';
import '../Services/chat_service.dart';

class ChatServiceProvider extends ChangeNotifier {
  late ChatService _chatService;
  bool _isInitialized = false;

  ChatServiceProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _chatService = ChatService();
    await _chatService.checkMicrophonePermission();
    _isInitialized = true;
    notifyListeners();
  }

  ChatService get chatService => _chatService;
  bool get isInitialized => _isInitialized;
}
