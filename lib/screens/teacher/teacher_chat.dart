import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/model/chat_room_model.dart';
import 'package:pre_school/model/firebasehelper.dart';
import 'package:pre_school/model/student_model.dart';
import 'package:pre_school/model/teacher_model.dart';
import 'package:pre_school/screens/teacher/chat_room_teacher.dart';

class TeacherChatPage extends StatefulWidget {
  final TeacherModel userModel;
  final User firebaseUser;

  const TeacherChatPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _TeacherChatPageState createState() => _TeacherChatPageState();
}

class _TeacherChatPageState extends State<TeacherChatPage> {
  late final DatabaseReference _studentsRef;

  @override
  void initState() {
    super.initState();
    _studentsRef = FirebaseDatabase.instance.ref("Students");
  }

  void navigateToChatRoomWithStudent(StudentModel student) async {
    String chatroomId = await FirebaseHelper.findOrCreateChatroom(widget.userModel.id, student.id);
    // Assuming you have a method in your ChatRoomPage to handle navigation and it accepts a chatRoomId.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          chatroom: ChatRoomModel(chatroomid: chatroomId), // Make sure your ChatRoomPage can handle this model correctly
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
          targetUser: student,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Chat"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: _studentsRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: Text("No students found."));
            }
            Map<dynamic, dynamic> studentsData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<StudentModel> students = studentsData.entries.map<StudentModel>((e) => StudentModel.fromMap(Map<String, dynamic>.from(e.value), e.key)).toList();

            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                StudentModel student = students[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(student.profilePictureUrl ?? ''),
                  ),
                  title: Text("${student.firstname} ${student.lastname}"),
                  onTap: () => navigateToChatRoomWithStudent(student),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
