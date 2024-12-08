import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/UI/constants/constants.dart';

import '../../Services/chat_service.dart';
import '../../providers/chat_service_provider.dart';
import '../Screens/chat_screen.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ChatService _chatService;
  bool _isListening = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _chatService =
        Provider.of<ChatServiceProvider>(context, listen: false).chatService;
  }

  void _handleSearch() {
    if (_searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
              initialQuery: _searchController.text,
              selectedLanguage: _selectedLanguage),
        ),
      );
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _chatService.stopListening();
      setState(() => _isListening = false);
      return;
    }

    final bool available = await _chatService.startListening(
      onResult: (text) {
        setState(() {
          _searchController.text = text;
          _isListening = false;
        });
      },
      onStatus: (status) {
        // Handle status updates if needed
      },
    );

    if (available) {
      setState(() => _isListening = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
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
                  IconButton(
                    icon: Image.asset(
                      "assets/images/ai-search.png",
                      height: 25,
                    ),
                    onPressed: _handleSearch,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Ask anything",
                        hintStyle: TextStyle(color: Color(0xFF12755F)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _handleSearch(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Islamic ',
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'AI',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/mic.png",
                      height: 25,
                    ),
                    onPressed: _toggleListening,
                  ),
                ],
              ),
            ),

            // Instructions
            const SizedBox(height: 32),
            Text(
              "How to use:",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInstructionItem(
              context,
              icon: Icons.keyboard,
              title: "Type your question",
              description:
                  "Enter any Islamic topic or question you'd like to learn about",
            ),
            _buildInstructionItem(
              context,
              icon: Icons.mic,
              title: "Voice Search",
              description:
                  "Tap the microphone icon and speak your question clearly",
            ),
            _buildInstructionItem(
              context,
              icon: Icons.search,
              title: "Search",
              description:
                  "Tap the search icon or press enter to get your answer",
            ),

            // Language Selection Instructions
            const SizedBox(height: 32),
            Text(
              "Select Language:",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose a language to receive responses:",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLanguageButton("Urdu"),
                _buildLanguageButton("English"),
                _buildLanguageButton("Arabic"),
                _buildLanguageButton("Turkish"),
                _buildLanguageButton("Hindi"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String language) {
    bool isSelected = _selectedLanguage == language;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.white,
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
        child: Text(
          language,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }
}
