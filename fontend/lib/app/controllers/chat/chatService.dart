import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/app/models/message.dart';
import 'package:e_commerce/app/models/user_chat.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChatService extends GetxController {
  //get instance of firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString receiverEmail = "".obs;
  RxString receiverId = "".obs;
  RxList<UserChatt> usersChat = <UserChatt>[].obs;
  var isLoaded = false.obs;
  Future<void> loadData() async {
    List<UserChatt> users = await getUserChat();
    usersChat.assignAll(users);
    isLoaded.value = true;
  }

  //get user stream
  Future<List<UserChatt>> getUserChat() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("Users").get();
    if (snapshot.docs.isNotEmpty) {
      final doc =
          snapshot.docs.map((e) => UserChatt.fromMap(e.data())).toList();
      return doc;
    }
    return [];
  }

  //get reReiverUid from firebase
  Future<String?> getReceiverUid(String receiverEmail) async {
    QuerySnapshot snapshot = await firestore
        .collection("Users")
        .where("email", isEqualTo: receiverEmail)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return doc.id;
    } else {
      return null;
    }
  }

  //get email from firebase

  Future<String?> getEmailFromUid(String uid) async {
    final snapshot = await firestore.collection("Users").doc(uid).get();
    if (snapshot.data() != null) {
      Map<String, dynamic>? user = snapshot.data();
      if (user != null) {
        return user["email"] ?? "";
      }
      return null;
    } else {
      return null;
    }
  }

  //send message
  Future<void> sendMessage(String senderId, String receiverId,
      String messageText, String email) async {
    final timestamp = Timestamp.now();
    final ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("-");
    final message = Message(
        senderId: senderId,
        receiverId: receiverId,
        timestamp: timestamp,
        messageText: messageText,
        email: email);
    // final lastMessage = {
    //   "lastMessage": messageText,
    //   "lastTimeMessage": timestamp,
    //   "email": email
    // };
    try {
      await firestore
          .collection("chat-room")
          .doc(chatRoomId)
          .collection("message")
          .add(message.toMap());

      // neu co thi update neu chua thi tao moi cac field
      await firestore.collection("conversations").doc(chatRoomId).set({
        'participants': ids,
        "lastMessage": messageText,
        "lastTimeMessage": timestamp,
        "email": email
      }, SetOptions(merge: true));

      // await firestore
      //     .collection("conversations")
      //     .doc(chatRoomId)
      //     .update(lastMessage);
    } catch (e) {
      throw e.toString();
    }
  }

  //get LastMessage
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(String myUserId) {
    return firestore
        .collection("conversations")
        .where("participants", arrayContains: myUserId)
        .orderBy("lastTimeMessage", descending: true)
        .snapshots();
  }

  // get message
  Stream<List<Message>> getMessage(String senderId, otherId, bool descending) {
    final ids = [senderId, otherId];

    ids.sort();
    String chatRoomId = ids.join("-");
    return firestore
        .collection("chat-room")
        .doc(chatRoomId)
        .collection("message")
        .orderBy("timestamp", descending: descending)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }

  //get user
}
