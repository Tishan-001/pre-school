class MessageModel {
  String messageid; // Consider making this non-nullable
  String sender; // Assume non-nullable for simplicity
  String text; // Assume non-nullable
  bool seen; // Assume non-nullable
  DateTime createdon; // Assume non-nullable

  // Assuming all required fields are non-nullable for simplicity
  MessageModel({
    required this.messageid,
    required this.sender,
    required this.text,
    required this.seen,
    required this.createdon,
  });

  // Adjusted fromMap constructor for Firebase Realtime Database
  MessageModel.fromMap(Map<String, dynamic> map, String id)
      : messageid = id,
        sender = map["sender"] ?? "",
        text = map["text"] ?? "",
        seen = map["seen"] ?? false,
        createdon = map["createdon"] != null ? DateTime.fromMillisecondsSinceEpoch(map["createdon"]) : DateTime.now(); // Provide a default value if null

  // Adjusted toMap method for Firebase Realtime Database
  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon.millisecondsSinceEpoch,
    };
  }
}
