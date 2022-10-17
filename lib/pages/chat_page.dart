import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/group_info.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          widget.groupName,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                  context,
                  GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin,
                  ),
                );
              },
              icon: const Icon(Icons.info_outline_rounded)),
        ],
      ),
    );
  }
}
