class UserChatt {
  String email;
  String uid;
  UserChatt({required this.email, required this.uid});

  factory UserChatt.fromMap(Map<String, dynamic> json) {
    return UserChatt(email: json["email"], uid: json["uid"]);
  }

  Map<String, dynamic> toMap() {
    return {"email": email, "uid": uid};
  }
}
