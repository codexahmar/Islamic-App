// import 'package:flutter/material.dart';
// import 'package:quran_app/UI/constants/constants.dart';
// import '../../Services/chat_service.dart';
// import 'package:provider/provider.dart';

// import '../../providers/chat_service_provider.dart';

// class ChatDialog extends StatefulWidget {
//   final String initialQuery;

//   const ChatDialog({
//     Key? key,
//     required this.initialQuery,
//   }) : super(key: key);

//   @override
//   _ChatDialogState createState() => _ChatDialogState();
// }

// class _ChatDialogState extends State<ChatDialog> {
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _controller = TextEditingController();
//   bool _isLoading = false;
//   bool _isListening = false;
//   late ChatService chatService;

//   @override
//   void initState() {
//     super.initState();
//     chatService =
//         Provider.of<ChatServiceProvider>(context, listen: false).chatService;
//     _sendQuery(widget.initialQuery);
//   }

//   Future<void> _sendQuery(String query) async {
//     setState(() {
//       _isLoading = true;
//       _messages.add(ChatMessage(text: query, isUser: true));
//     });

//     try {
//       final response = await chatService.getChatResponse(query);
//       setState(() {
//         _messages.add(ChatMessage(text: response, isUser: false));
//       });
//     } catch (e) {
//       setState(() {
//         _messages
//             .add(ChatMessage(text: "Error: ${e.toString()}", isUser: false));
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _handleSend() {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       _sendQuery(text);
//       _controller.clear();
//     }
//   }

//   // Function for voice input
//   Future<void> _handleVoiceSearch() async {
//     final hasPermission = await chatService.checkMicrophonePermission();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Microphone permission required!")),
//       );
//       return;
//     }

//     final result = await chatService.startListening(
//       onResult: (text) {
//         setState(() {
//           _controller.text = text;
//         });
//         _handleSend();
//       },
//       onStatus: (status) {
//         if (status == 'done') {
//           chatService.stopListening();
//         }
//       },
//     );

//     // if (!result) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text("Failed to start voice recognition.")),
//     //   );
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.85,
//           height: MediaQuery.of(context).size.height * 0.6,
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _messages[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Align(
//                         alignment: message.isUser
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Material(
//                           color: message.isUser
//                               ? primaryColor!
//                               : Colors.grey[200]!,
//                           borderRadius: BorderRadius.circular(15),
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text(
//                               message.text,
//                               style: TextStyle(
//                                 color: message.isUser
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               if (_isLoading)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: CircularProgressIndicator(),
//                 ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         hintText: 'Type your message...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isListening ? Icons.mic : Icons.mic_none,
//                             color: primaryColor,
//                           ),
//                           onPressed: _handleVoiceSearch,
//                           tooltip: 'Start/Stop Listening',
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send, color: primaryColor),
//                     onPressed: _handleSend,
//                     tooltip: 'Send Message',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
