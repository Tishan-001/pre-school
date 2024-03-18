import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme.dart';
import '../../widgets/checkbox.dart';

class EditStudentScreen extends StatefulWidget {
  final String uid; // Assuming you're passing the UID of the user to edit

  const EditStudentScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _imageUrl;
  final picker = ImagePicker();

  bool isAccept = false;

  @override
  void initState() {
    super.initState();
    _fetchStudentData(); // Call the method to fetch student data
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudentData() async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Students').child(widget.uid);

    try {
      DatabaseEvent event = await dbRef.once();
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        _firstnameController.text = data['firstname'] ?? '';
        _lastnameController.text = data['lastname'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        String imageUrl = data['profilePictureUrl'] ?? '';
        if (imageUrl.isNotEmpty) {
          setState(() {
            _imageUrl = imageUrl;
          });
        }
        setState(() {
          isAccept = data['accept'] ?? false;
        });
      }
    } catch (e) {
      print("Error fetching student data: $e");
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadFile(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("student_images/$fileName");
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        String imageUrl = await ref.getDownloadURL();
        await _updateStudentInformation(imageUrl); // Pass the image URL to the save function
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _updateStudentInformation(String imageUrl) async {
    final DatabaseReference db = FirebaseDatabase.instance.reference().child("Students");

    try {
      final studentData = {
        "firstname": _firstnameController.text.trim(),
        "lastname": _lastnameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "profilePictureUrl": imageUrl,
        "accept": isAccept,
      };

      await db.child(widget.uid).update(studentData);

      Navigator.pop(context); // Go back on successful update
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none, // Allow overflow outside of the Stack boundaries
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                      backgroundColor: Colors.grey[200],
                      child: _imageUrl == null ? const Icon(Icons.person, size: 50) : Container(),
                    ),
                    Positioned(
                      right: -15, // Adjust these values to position the icon correctly
                      top: 2, // Position above the CircleAvatar
                      child: GestureDetector(
                        onTap: getImage, // Method to update the image
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 20,
                          child: const Icon(Icons.add_a_photo_outlined, size: 25, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the last name';
                  }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CheckBox(
                    'Student Accept',
                    value: isAccept,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isAccept = newValue ?? false;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Only update student information, assuming image has already been picked and uploaded
                        _updateStudentInformation(_imageUrl ?? ''); // Use existing _imageUrl
                      }
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
