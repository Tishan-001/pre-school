import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/model/chat_room_model.dart';
import 'package:pre_school/model/firebasehelper.dart';
import 'package:pre_school/model/teacher_model.dart';
import 'package:pre_school/model/student_model.dart';
import 'package:pre_school/screens/student/chat_room_student.dart';

class StudentChatPage extends StatefulWidget {
  final StudentModel userModel;
  final User firebaseUser;

  const StudentChatPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _StudentChatPageState createState() => _StudentChatPageState();
}

class _StudentChatPageState extends State<StudentChatPage> {
  late final DatabaseReference _teachersRef;

  @override
  void initState() {
    super.initState();
    _teachersRef = FirebaseDatabase.instance.ref("Teachers");
  }

  void navigateToChatRoomWithTeacher(TeacherModel teacher) async {
    String chatroomId = await FirebaseHelper.findOrCreateChatroom(teacher.id, widget.userModel.id);
    // Navigate to ChatRoomPage, ensure it can handle the provided model correctly
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentChatRoomPage(
          chatroom: ChatRoomModel(chatroomid: chatroomId),
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
          targetUser: teacher, // This assumes your ChatRoomPage accepts a generic user model or you have different handling for TeacherModel
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Chat"),
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: _teachersRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: Text("No teachers found."));
            }
            Map<dynamic, dynamic> teachersData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<TeacherModel> teachers = teachersData.entries.map<TeacherModel>((e) => TeacherModel.fromMap(Map<String, dynamic>.from(e.value), e.key)).toList();

            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                TeacherModel teacher = teachers[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/default_student.jpg'),
                  ),
                  title: Text("${teacher.firstname} ${teacher.lastname}"),
                  onTap: () => navigateToChatRoomWithTeacher(teacher),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
