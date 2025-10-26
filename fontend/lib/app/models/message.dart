import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  Timestamp timestamp;
  String messageText;
  String email;
  Message({
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.messageText,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": timestamp,
      "messageText": messageText,
      "email": email
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        senderId: map["senderId"] ?? "",
        receiverId: map["receiverId"] ?? "",
        timestamp: map["timestamp"] ?? "",
        messageText: map["messageText"] ?? "",
        email: map["email"] ?? "");
  }
}
