import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/model/teacher_model.dart';
import 'package:pre_school/screens/login.dart';
import 'package:pre_school/widgets/profile_menu.dart';


class TeacherProfile extends StatefulWidget {

  TeacherProfile({Key? key}) : super(key: key);

  @override
  _TeacherProfilePicState createState() => _TeacherProfilePicState();
}

class _TeacherProfilePicState extends State<TeacherProfile> {
  TeacherModel? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('Teachers/${user.uid}');
      DatabaseEvent event = await ref.once();

      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          currentUser = TeacherModel.fromMap(Map<String, dynamic>.from(data), user.uid);
        });
      }
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen (replace 'LoginScreen()' with your login screen widget)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LogInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Profile"),
        automaticallyImplyLeading: false,
        elevation: 2.0,
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}