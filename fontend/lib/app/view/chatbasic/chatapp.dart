import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/controllers/chat/chatService.dart';
import 'package:e_commerce/utils/mystorage/shared-pres.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});
  @override
  State<ChatApp> createState() => _ChatApp();
}

class _ChatApp extends State<ChatApp> {
  final chatService = Get.find<ChatService>();
  final auth = AuthService.auth;
  @override
  void initState() {
    super.initState();
    chatService.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _searchUser(),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: StreamBuilder(
                stream: chatService.getLastMessages(auth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("errorr: ${snapshot.error}"),
                    );
                  }
                  final users =
                      snapshot.data!.docs.map((data) => data.data()).toList();
                  if (users.isEmpty) {
                    return const Center(child: Text("Khong co nguoi dung nao"));
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildUserListItem(user, context);
                    },
                  );
                },
              )),
            ],
          ),
        ));
  }

  Widget _searchUser() {
    return Obx(() {
      if (!chatService.isLoaded.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return SearchAnchor.bar(
        suggestionsBuilder: (context, controller) {
          final users = chatService.usersChat;
          return users
              .where((user) =>
                  user.uid != auth.currentUser!.uid &&
                  (controller.text.isEmpty ||
                      user.email
                          .toLowerCase()
                          .contains(controller.text.toLowerCase())))
              .map(
                (e) => ListTile(
                  title: Text("hi ${e.email}"),
                  onTap: () async {
                    // await SharedPres.setReceiverUid(e.uid);
                    // await SharedPres.setReceiverEmail(e.email);
                    chatService.receiverId.value = e.uid;
                    chatService.receiverEmail.value = e.email;
                    controller.closeView(e.email);
                    Get.toNamed("chatroom");
                  },
                ),
              )
              .toList();
        },
      );
    });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext content) {
    List participants = userData['participants'];
    String otherId = participants.firstWhere(
      (e) => e != auth.currentUser!.uid,
    );

    return FutureBuilder(
      future: chatService.getEmailFromUid(otherId),
      builder: (context, snapshot) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            snapshot.data ?? otherId,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(userData["lastMessage"]),
          onTap: () async {
            // await SharedPres.setReceiverUid(otherId);
            // await SharedPres.setReceiverEmail(snapshot.data ?? "none");
            chatService.receiverEmail.value = snapshot.data ?? "no data";
            chatService.receiverId.value = otherId;
            await Get.toNamed('chatroom');
          },
        );
      },
    );
  }
}
//userData["email"] != auth.currentUser!.email
