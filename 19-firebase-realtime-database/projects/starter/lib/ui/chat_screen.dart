import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raychat/message.dart';
import 'package:raychat/messages.dart';
import 'package:raychat/ui/message_widget.dart';
import 'package:raychat/users.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final Messages _messages;
  late final Users _users;
  Future _sendStatus = Future.value();

  @override
  void initState() {
    _messages = context.read<Messages>();
    _users = context.read<Users>();
    super.initState();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RayChat'),
        actions: [
          IconButton(
            onPressed: () => _users.logOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    onSubmitted: (msg) {
                      _sendMessage(msg);
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Enter new message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_msgController.text),
                )
              ],
            ),
            _chatStatus(),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String msg) {
    if (msg.length > 0) {
      setState(() {
        _sendStatus = _messages.send(msg);
      });
      _msgController.clear();
      _scrollToBottom();
    }
  }

  Widget _chatStatus() {
    return FutureBuilder(
      future: _sendStatus,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Container();
      },
    );
  }

  Widget _buildMessagesList() => StreamBuilder<List<Message>>(
        stream: _messages.stream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          }
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => MessageWidget(messages[index]),
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
            );
          }
          return Center(
            child: Text('Error loading messages 😨\n${snapshot.error}'),
          );
        },
      );

  bool get _canSendMessage => _msgController.text.length > 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
