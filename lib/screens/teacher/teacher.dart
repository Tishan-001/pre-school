import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pre_school/model/student_model.dart';
import 'package:pre_school/screens/teacher/add_student_form.dart';
import 'package:pre_school/screens/teacher/edit_student.dart';

class Teacher extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<Teacher> {
  final List<StudentModel> _students = [];
  final _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _database.child('Students').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final allStudents = Map<String, dynamic>.from(event.snapshot.value as Map);
        final studentList = allStudents.entries.map((e) =>
            StudentModel.fromMap(Map<String, dynamic>.from(e.value), e.key)).toList();

        setState(() {
          _students.clear();
          _students.addAll(studentList);
        });
      } else {
        setState(() {
          _students.clear();
        });
      }
    }, onError: (error) {
      print('Database listen error: $error');
    });
  }

  void _deleteStudent(String studentId) async {
    // Assuming studentId is a unique identifier for each student.
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Students/$studentId");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: const Text("Are you sure you want to delete this student?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  // Delete the student from the database
                  await dbRef.remove();
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Student deleted successfully")),
                  );
                  _activateListeners();
                } catch (error) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to delete student: $error")),
                  );
                }
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }


  void _editStudent(String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(uid: uid),
      ),
    ).then((value) {
      // Optionally, refresh the list of students upon returning to this screen
      // in case any details were updated.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Home"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: _students[index].profilePictureUrl?.isNotEmpty == true
                  ? NetworkImage(_students[index].profilePictureUrl!)
                  : AssetImage('assets/default_student.jpg') as ImageProvider,
            ),
            title: Text('${_students[index].firstname} ${_students[index].lastname}'),
            subtitle: Text(_students[index].email),
            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editStudent(_students[index].id),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteStudent(_students[index].id), // Adjust based on your unique identifier
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Student',
      ),
    );
  }
}
