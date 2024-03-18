import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_image == null) {
      // Show a dialog if no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("No Image Selected"),
            content: const Text("Please select an image."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function if no image is selected
    }

    // If an image is selected, proceed with the upload
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("student_images/$fileName");
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.whenComplete(() async {
      String imageUrl = await ref.getDownloadURL();
      _saveStudentToFirebase(imageUrl); // Pass the image URL to the save function
    });
  }

  Future<void> _saveStudentToFirebase(String imageUrl) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (_firstnameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Validation Error"),
            content: Text("First name, email, and password cannot be empty."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Exit if validation fails
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If the user is successfully created, save additional information in the database
      final DatabaseReference db = FirebaseDatabase.instance.reference().child("Students");
      final studentData = {
        "firstname": _firstnameController.text.trim(),
        "lastname": _lastnameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "password": _phoneController.text.trim(),
        "profilePictureUrl": imageUrl,
        "accept": true,
      };

      await db.child(userCredential.user!.uid).set(studentData);
      Navigator.pop(context); // Go back to the previous screen on success
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to create user. Please try again.";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An unexpected error occurred. Please try again."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    backgroundColor: Colors.grey[200],
                    child: _image == null ? const Icon(Icons.add_a_photo, size: 50) : Container(), // Fallback color
                  ),
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
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        uploadFile(); // Start the upload process
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
