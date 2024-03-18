import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static Future<String> findOrCreateChatroom(String teacherId, String studentId) async {
    DatabaseReference chatroomsRef = FirebaseDatabase.instance.ref("chatrooms");

    // First, check if a chatroom already exists between the teacher and the student
    DatabaseEvent event = await chatroomsRef.orderByChild("participants/$teacherId").equalTo(true).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      // Here we make sure to safely cast the snapshot value to a Map
      final chatroomsData = snapshot.value as Map<dynamic, dynamic>?;

      if (chatroomsData != null) {
        // Iterate through existing chatrooms to find a match
        for (var entry in chatroomsData.entries) {
          final chatroomData = Map<String, dynamic>.from(entry.value);
          if (chatroomData["participants"] != null &&
              chatroomData["participants"][studentId] == true) {
            // Found an existing chatroom, return its ID
            return entry.key;
          }
        }
      }
    }

    // If no existing chatroom found, create a new one
    DatabaseReference newChatroomRef = chatroomsRef.push();
    await newChatroomRef.set({
      "participants": {
        teacherId: true,
        studentId: true,
      },
      // You can add additional fields here, like lastMessage, timestamps, etc.
    });

    return newChatroomRef.key!;
  }
}
