import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final int userId;
  final String name;

  const ChatPage({super.key, required this.userId, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msg = TextEditingController();
  List<String> messages = [];

  void send() {
    if (msg.text.isEmpty) return;

    setState(() {
      messages.add(msg.text);
      msg.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (c, i) => ListTile(
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.orange[200],
                    child: Text(messages[i]),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(controller: msg),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: send,
              )
            ],
          )
        ],
      ),
    );
  }
}