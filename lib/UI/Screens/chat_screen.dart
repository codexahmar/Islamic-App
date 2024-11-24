import 'package:flutter/material.dart';
import 'package:quran_app/UI/constants/constants.dart';
import '../../Services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isListening = false;
  // bool _isSpeaking = false;
  String _listeningStatus = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _chatService.loadMessages();
      setState(() {
        _messages.addAll(messages);
        _isInitialized = true;
      });
      _scrollToBottom();
    } catch (e) {
      print("Load Messages Error: $e");
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    _controller.clear();

    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
    });

    _scrollToBottom();

    try {
      final chatResponse = await _chatService.getChatResponse(userMessage);
      setState(() {
        _messages.add(ChatMessage(
          text: chatResponse,
          isUser: false,
        ));
        _isLoading = false;
      });

      await _chatService.saveMessages(_messages);
      _scrollToBottom();

      // if (_isSpeaking) {
      //   await _chatService.speakResponse(chatResponse);
      // }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
        ));
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Oops! I couldn’t process that. Please try again or ask something else.',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      // Stop listening if already listening
      await _chatService.stopListening();
      setState(() {
        _isListening = false;
        _listeningStatus = '';
      });
      return;
    }

    // Start listening for speech
    final bool available = await _chatService.startListening(
      onResult: (text) {
        setState(() {
          _controller.text = text; // Populate the text field
          _isListening = false;
          _listeningStatus = '';
        });
      },
      onStatus: (status) {
        setState(() {
          // Update UI based on the status
          _listeningStatus = status == 'listening' ? 'Listening...' : '';
        });
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _listeningStatus = 'Listening...';
      });
    } else {
      // Show a snackbar if speech recognition could not start
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Listening....'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // void _toggleSpeaking() async {
  //   setState(() => _isSpeaking = !_isSpeaking);
  //   if (!_isSpeaking) {
  //     await _chatService.stopSpeaking();
  //   }
  // }

  void _clearChat() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat History'),
        content: Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _chatService.clearHistory();
              setState(() => _messages.clear());
              Navigator.pop(context);
            },
            child: Text('Clear'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Islamic Chatbot',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearChat,
            tooltip: 'Clear Chat History',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_listeningStatus.isNotEmpty)
            Container(
              color: primaryColor.withOpacity(0.2),
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _listeningStatus,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 8,
                  color: Colors.black26,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.grey[600],
                      ),
                      onPressed: _toggleListening,
                      tooltip: 'Voice Input',
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Ask your question...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.8),
                            primaryColor.withOpacity(1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            gradient: message.isUser
                ? LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.8),
                      primaryColor.withOpacity(1),
                    ],
                  )
                : LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[100]!]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 3),
                blurRadius: 5,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    // _chatService.stopSpeaking();
    _chatService.stopListening();
    super.dispose();
  }
}
