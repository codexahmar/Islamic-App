import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/chat_service.dart';
import '../../providers/chat_service_provider.dart';
import 'chatdialog.dart';

class SearchBarComponent extends StatefulWidget {
  const SearchBarComponent({Key? key}) : super(key: key);

  @override
  _SearchBarComponentState createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  late ChatService chatService;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); 
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatServiceProvider>(context, listen: false).chatService;
  }

  void _openChatDialog(String query) {
    showDialog(
      context: context,
      builder: (context) => ChatDialog(
        initialQuery: query,
      ),
    );
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      _openChatDialog(query);
      _controller.clear(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        
        FocusScope.of(context)
            .requestFocus(FocusNode()); 
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
                focusNode: _focusNode, 
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
