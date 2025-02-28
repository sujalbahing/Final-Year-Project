// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:krishi/utils/api_endpoints.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatRoomName; // Chat room identifier

//   const ChatScreen({super.key, required this.chatRoomName});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Map<String, String>> messages = []; // Stores chat messages
//   late IOWebSocketChannel channel;
//   TextEditingController messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _connectToWebSocket();
//     _fetchChatHistory();
//   }

//   /// **Fetch previous chat messages from API**
//   Future<void> _fetchChatHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('access_token');

//     if (token == null) {
//       print("No token found. User not logged in.");
//       return;
//     }

//     final url = Uri.parse('${ApiEndPoints.baseUrl}messages/${widget.chatRoomName}/');
//     final response = await http.get(url, headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     });

//     if (response.statusCode == 200) {
//       List<dynamic> chatData = json.decode(response.body);
//         setState(() {
//           messages = chatData.map((msg) => {
//             "sender": msg["sender"].toString(),  // ✅ Converts to String
//             "content": msg["content"].toString(), // ✅ Converts to String
//           }).toList();
//         });
//     } else {
//       print("Failed to load chat history: ${response.body}");
//     }
//   }

//   /// **Connect to WebSocket for real-time chat**
//   void _connectToWebSocket() {
//     final wsUrl = 'ws://yourserver.com/ws/chat/${widget.chatRoomName}/';
//     channel = IOWebSocketChannel.connect(wsUrl);

//     channel.stream.listen((message) {
//       final data = json.decode(message);
//       setState(() {
//         messages.add({
//           "sender": data["sender"],
//           "content": data["message"],
//         });
//       });
//     });
//   }

//   /// **Send message via WebSocket**
//   void _sendMessage() {
//     if (messageController.text.isNotEmpty) {
//       final message = json.encode({
//         "message": messageController.text.trim(),
//       });

//       channel.sink.add(message); // Send message to WebSocket
//       messageController.clear();
//     }
//   }

//   @override
//   void dispose() {
//     channel.sink.close(); // Close WebSocket when leaving screen
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat Room: ${widget.chatRoomName}")),
//       body: Column(
//         children: [
//           // ✅ Chat Messages List
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 bool isMe = messages[index]["sender"] == "You"; // Adjust based on authentication
//                 return Align(
//                   alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blue[200] : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           messages[index]["sender"]!,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 5),
//                         Text(messages[index]["content"]!),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // ✅ Message Input Box
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blue),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }