import 'package:flutter/material.dart';
import 'package:pre_school/screens/student/gallery.dart';
import 'package:pre_school/screens/student/home.dart';
import 'package:pre_school/screens/student/profile.dart';
import 'package:pre_school/screens/student/student.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // Assuming Home, GalleryPage, and Student are defined elsewhere
  final List<Widget> _widgetOptions = [
    Home(), // Replace Home with your Home widget
    GalleryPage(), // Replace GalleryPage with your GalleryPage widget
    Student(), // Replace Student with your Student widget
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
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
            icon: Icon(Icons.school),
            label: 'Student',
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
