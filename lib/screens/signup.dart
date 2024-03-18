import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/screens/login.dart';
import 'package:pre_school/theme.dart';
import 'package:pre_school/widgets/checkbox.dart';
import 'package:pre_school/widgets/login_option.dart';
import 'package:pre_school/widgets/primary_button.dart';
import 'package:pre_school/widgets/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>  {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformpasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool isTeacher = false;
  bool isStudent = false;

  Future<void> signUpWithEmailPassword(String email, String password, String phone, String firstName, String lastName) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String uid = userCredential.user!.uid;

        if (isTeacher) {
          final DatabaseReference dbTeacher = FirebaseDatabase.instance.reference().child("Teachers");
          final teacherData = {
            "firstname": firstName,
            "lastname": lastName,
            "email": email,
            "password": password,
            "phone": phone,
          };
          await dbTeacher.child(uid).set(teacherData);
        }

        if (isStudent) {
          final DatabaseReference dbStudent = FirebaseDatabase.instance.reference().child("Students");
          final studentData = {
            "firstname": firstName,
            "lastname": lastName,
            "email": email,
            "password": password,
            "profilePictureUrl": null,
            "accept": false,
          };
          await dbStudent.child(uid).set(studentData);
        }

      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    } else {
      print("Email and password must not be empty");
    }
  }

  void _signUp(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String conformPassword = _conformpasswordController.text.trim();
    final String phone = _phoneController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Signup Failed"),
          content: Text("Email and Password must not be empty"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    if (password != conformPassword) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Signup Failed"),
          content: Text("Password not match"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    try {
      await signUpWithEmailPassword(email, password, phone, firstName, lastName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LogInScreen()));
      print("User registered successfully");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Create Account',
                style: titleText,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text(
                    'Already a member?',
                    style: subTitle,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()));
                    },
                    child: Text(
                      'Log In',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: kDefaultPadding,
              child: SignUpForm(
                emailController: _emailController, // Passed to SignUpForm
                passwordController: _passwordController, // Passed to SignUpForm
                conformpasswordController: _conformpasswordController,
                phoneController: _phoneController,
                fistNameController: _firstNameController,
                lastNameController: _lastNameController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: CheckBox(
                'Teacher',
                value: isTeacher,
                onChanged: (value) {
                  setState(() {
                    isTeacher = value!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: CheckBox(
                'Student',
                value: isStudent,
                onChanged: (value) {
                  setState(() {
                    isStudent = value!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: PrimaryButton(
                buttonText: 'Sign Up',
                onPressed: () => _signUp(context), // Assuming PrimaryButton accepts an onPressed callback
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Or log in with:',
                style: subTitle.copyWith(color: kBlackColor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: LoginOption(),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
