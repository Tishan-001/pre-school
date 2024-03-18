import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pre_school/model/teacher_model.dart';
import 'package:pre_school/screens/teacher/gallery_add.dart';
import 'package:pre_school/screens/teacher/teacher.dart';
import 'package:pre_school/screens/teacher/teacher_chat.dart';
import 'package:pre_school/screens/teacher/teacher_profile.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int _currentIndex = 0;
  TeacherModel? currentUser;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  // Widgets will be initialized later, after fetching the current user
  List<Widget> _widgetOptions = [];

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
          // Now that we have the user, initialize the widget options
          _initializeWidgetOptions();
        });
      }
    }
  }

  void _initializeWidgetOptions() {
    _widgetOptions = [
      Teacher(),
      GalleryTeacherPage(),
      if (currentUser != null && firebaseUser != null) // Check for non-null values before initializing
        TeacherChatPage(userModel: currentUser!, firebaseUser: firebaseUser!),
      TeacherProfile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Make sure to check for currentUser before building the UI
    return Scaffold(
      body: currentUser == null ? Center(child: CircularProgressIndicator()) : IndexedStack(
        index: _currentIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
