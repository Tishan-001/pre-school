import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/model/student_model.dart'; // Make sure this import is correct
import 'package:pre_school/screens/login.dart';
import 'package:pre_school/screens/student/my_account.dart';
import 'package:pre_school/screens/student/student_chat.dart';
import 'package:pre_school/widgets/profile_menu.dart';
import 'package:pre_school/widgets/profile_pic.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  StudentModel? currentUser;
  User? firebaseUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('Students/${firebaseUser!.uid}');
      DatabaseEvent event = await ref.once();

      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          currentUser = StudentModel.fromMap(Map<String, dynamic>.from(data), firebaseUser!.uid);
        });
      }
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
        elevation: 2.0,
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccountPage())),
            ),
            if (currentUser != null && firebaseUser != null) // Ensure currentUser and firebaseUser are not null
              ProfileMenu(
                text: "Chat with Teacher",
                icon: "assets/icons/Chat.svg",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentChatPage(userModel: currentUser!, firebaseUser: firebaseUser!)),
                ),
              ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
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
