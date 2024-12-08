import 'package:flutter/material.dart';
import 'package:quran_app/UI/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../Services/chat_service.dart';
import '../../providers/chat_service_provider.dart';

class ChatScreen extends StatefulWidget {
  final String? initialQuery;
  final String? selectedLanguage;

  const ChatScreen({Key? key, this.initialQuery, this.selectedLanguage})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ChatService _chatService;
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isListening = false;
  String _listeningStatus = '';
  bool _isInitialized = false;

  // List of predefined Islamic prompts
  List<String> _prompts = [
    "Tell me about the Quran",
    "What are the 99 names of Allah?",
    "What is Zakat?",
    "Tell me about the Prophets",
    "What is the significance of Ramadan?",
    "Tell me about Hajj",
  ];

  bool _showPrompts = true; // Control whether prompts are shown

  @override
  void initState() {
    super.initState();
    _chatService =
        Provider.of<ChatServiceProvider>(context, listen: false).chatService;

    // First load existing messages
    _loadMessages().then((_) {
      // Then handle initial query if provided
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        _handleInitialQuery();
      }
    });

    _checkIfPromptsShown();
  }

  Future<void> _handleInitialQuery() async {
    final userMessage = widget.initialQuery!;
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
    });

    setState(() => _isLoading = true);
    try {
      final chatResponse = await _chatService.getChatResponse(
          userMessage, widget.selectedLanguage!);
      setState(() {
        _messages.add(ChatMessage(
          text: chatResponse,
          isUser: false,
        ));
        _isLoading = false;
      });

      // Save all messages including the new ones
      await _chatService.saveMessages(_messages);
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
        ));
        _isLoading = false;
      });
    }
  }

  // Check if the user has already clicked on a prompt and update the state accordingly
  Future<void> _checkIfPromptsShown() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showPrompts = prefs.getBool('showPrompts') ?? true;
    });
  }

  // Store in SharedPreferences that the user has interacted with the prompts
  Future<void> _setPromptsShown() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showPrompts', false);
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
      final chatResponse = await _chatService.getChatResponse(
          userMessage, widget.selectedLanguage!);
      setState(() {
        _messages.add(ChatMessage(
          text: chatResponse,
          isUser: false,
        ));
        _isLoading = false;
      });

      await _chatService.saveMessages(_messages);
      _scrollToBottom();
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
      await _chatService.stopListening();
      setState(() {
        _isListening = false;
        _listeningStatus = '';
      });
      return;
    }

    final bool available = await _chatService.startListening(
      onResult: (text) {
        setState(() {
          _controller.text = text;
          _isListening = false;
          _listeningStatus = '';
        });
      },
      onStatus: (status) {
        setState(() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Listening....'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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

  // Handle tap on prompt to fill text field, hide all prompts and store flag
  void _handlePromptTap(String prompt) {
    setState(() {
      _controller.text = prompt;
      _prompts.clear(); // Clear all prompts after user clicks one
      _showPrompts = false;
    });
    _setPromptsShown(); // Store flag to prevent prompts on next load
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
        iconTheme: IconThemeData(color: Colors.white),
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
          // Display predefined prompts as capsules if user hasn't clicked any
          if (_showPrompts && _prompts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _prompts.map((prompt) {
                  return GestureDetector(
                    onTap: () => _handlePromptTap(prompt),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: primaryColor),
                      ),
                      child: Text(
                        prompt,
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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
                  if (index == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // TextField for typing messages
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: primaryColor,
                        ),
                        onPressed: _toggleListening, // Start or stop listening
                        tooltip: 'Start/Stop Listening',
                      ),
                    ),
                  ),
                ),

                // Send button
                IconButton(
                  icon: Icon(Icons.send, color: primaryColor),
                  onPressed: _sendMessage,
                  tooltip: 'Send Message',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: message.isUser ? primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
