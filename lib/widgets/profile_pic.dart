import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/student_model.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  StudentModel? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('Students/${user.uid}');
      DatabaseEvent event = await ref.once();

      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          currentUser = StudentModel.fromMap(Map<String, dynamic>.from(data), user.uid);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: currentUser?.profilePictureUrl?.isNotEmpty == true
                ? NetworkImage(currentUser!.profilePictureUrl!)
                : AssetImage('assets/default_student.jpg') as ImageProvider,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(color: Colors.white),
                ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}