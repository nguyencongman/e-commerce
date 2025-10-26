class LastMessage {
  String lastMessage;
  String lastTimeMessage;
  String email;
  LastMessage(
      {required this.lastMessage,
      required this.lastTimeMessage,
      required this.email});

  factory LastMessage.fromMap(Map<String, dynamic> json) {
    return LastMessage(
        lastMessage: json["lastMessage"],
        lastTimeMessage: json["lastTimeMessage"],
        email: json["email"]);
  }
  Map<String, dynamic> toMap() {
    return {
      "lastMessage": lastMessage,
      "lastTimeMessage": lastTimeMessage,
      "email": email
    };
  }
}
