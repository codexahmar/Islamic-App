import 'package:flutter/material.dart';
import '../../Services/chat_service.dart';
import '../Screens/chatdialog.dart';

class SearchBarComponent extends StatefulWidget {
  final ChatService chatService;

  const SearchBarComponent({Key? key, required this.chatService})
      : super(key: key);

  @override
  _SearchBarComponentState createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode to manage focus
  bool _isLoading = false;

  void _openChatDialog(String query) {
    showDialog(
      context: context,
      builder: (context) => ChatDialog(
        chatService: widget.chatService,
        initialQuery: query,
      ),
    );
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      _openChatDialog(query);
      _controller.clear(); // Clear the text field after search
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove focus from the TextField when tapping outside
        FocusScope.of(context)
            .requestFocus(FocusNode()); // This removes the cursor
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode, // Attach FocusNode to TextField
                decoration: const InputDecoration(
                  hintText: "Ask anything from Islamic Chatbot",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: _isLoading ? null : _handleSearch,
            ),
          ],
        ),
      ),
    );
  }
}
