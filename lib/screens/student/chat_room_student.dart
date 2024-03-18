import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/model/chat_room_model.dart';
import 'package:pre_school/model/message.dart';
import 'package:pre_school/model/student_model.dart';
import 'package:pre_school/model/teacher_model.dart';

class StudentChatRoomPage extends StatefulWidget {
  final TeacherModel targetUser;
  final ChatRoomModel chatroom;
  final StudentModel userModel;
  final User firebaseUser;

  const StudentChatRoomPage({
    Key? key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _StudentChatRoomPageState createState() => _StudentChatRoomPageState();
}

class _StudentChatRoomPageState extends State<StudentChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      String messageId = FirebaseDatabase.instance.ref().child('messages').push().key ?? '';

      MessageModel newMessage = MessageModel(
        messageid: messageId,
        sender: widget.userModel.id, // Assuming 'id' is a correct field in your StudentModel
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      // Saving message
      FirebaseDatabase.instance.ref("chatrooms/${widget.chatroom.chatroomid}/messages/$messageId").set(newMessage.toMap());

      // Updating last message in chatroom info
      FirebaseDatabase.instance.ref("chatrooms/${widget.chatroom.chatroomid}").update({"lastMessage": msg});

      log("Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFE6E6),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage('assets/default_student.jpg'), // Assuming TeacherModel has profilePictureUrl
            ),
            SizedBox(width: 10),
            Text(widget.targetUser.firstname), // Assuming TeacherModel has firstname
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance.ref("chatrooms/${widget.chatroom.chatroomid}/messages").orderByChild("createdon").onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic> messages = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
                      List<MessageModel> messageList = [];
                      messages.forEach((key, value) {
                        messageList.add(MessageModel.fromMap(Map<String, dynamic>.from(value), key));
                      });
                      messageList.sort((a, b) => b.createdon.compareTo(a.createdon)); // Assuming 'createdon' can be compared directly

                      return ListView.builder(
                        reverse: true,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = messageList[index];

                          return Row(
                            mainAxisAlignment: currentMessage.sender == widget.userModel.id ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: currentMessage.sender == widget.userModel.id ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  currentMessage.text.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("An error occurred! Please check your internet connection."),
                      );
                    } else {
                      return Center(child: Text("Say hi to your new friend"));
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Enter message"),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
