import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/model/student_model.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: currentUser!.profilePictureUrl?.isNotEmpty == true
                      ? NetworkImage(currentUser!.profilePictureUrl!)
                      : AssetImage('assets/default_student.jpg') as ImageProvider,
                ),
                SizedBox(width: 10),
                Text('${currentUser!.firstname} ${currentUser!.lastname}', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            Text('Email: ${currentUser!.email}'),
            Text('First Name: ${currentUser!.firstname}'),
            Text('Last Name: ${currentUser!.lastname}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
