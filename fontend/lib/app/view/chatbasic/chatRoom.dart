import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/controllers/chat/chatService.dart';
import 'package:e_commerce/app/view/widgets/TextField.dart';
import 'package:e_commerce/utils/constants/FormatText.dart';
import 'package:e_commerce/utils/mystorage/shared-pres.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chatroom extends StatefulWidget {
  Chatroom({super.key});
  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final chat = Get.find<ChatService>();
  final auth = AuthService.auth;
  final messageController = TextEditingController();
  final scroll = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FText.TextTitle("${chat.receiverEmail}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: _BuildMessage(context),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldV2(
                        controller: messageController,
                        label: "please enter content"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {
                        chat.sendMessage(
                            auth.currentUser!.uid,
                            chat.receiverId.value,
                            messageController.text,
                            auth.currentUser!.email!);
                        messageController.clear();
                        scroll.animateTo(scroll.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.send)),
                  IconButton(
                      onPressed: () {
                        print("uid ${chat.receiverId.value}");
                        print("receiverEmail ${chat.receiverEmail.value}");
                      },
                      icon: Icon(Icons.abc))
                ],
              ))
        ],
      ),
    );
  }

  Widget _BuildMessage(BuildContext context) {
    return StreamBuilder(
      stream:
          chat.getMessage(auth.currentUser!.uid, chat.receiverId.value, false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final messages = snapshot.data;

        return ListView.builder(
          controller: scroll,
          itemCount: messages!.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            bool isMe = auth.currentUser!.uid == message.senderId;
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: Get.width * 0.4, minWidth: Get.width * 0.1),
                    child: Container(
                      decoration: BoxDecoration(
                          color: isMe ? Colors.lightBlue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          message.messageText,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  )),
            );
          },
        );
      },
    );
  }
}
