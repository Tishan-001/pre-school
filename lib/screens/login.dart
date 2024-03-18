import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/screens/reset_password.dart';
import 'package:pre_school/screens/signup.dart';
import 'package:pre_school/screens/teacher/teacher_page.dart';
import 'package:pre_school/theme.dart';
import 'package:pre_school/widgets/login_form.dart';
import 'package:pre_school/widgets/login_option.dart';
import 'package:pre_school/widgets/primary_button.dart';

import 'student/myHomePage.dart';

class LogInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  Future<String> getUserRole(String userId) async {
    final dbRef = FirebaseDatabase.instance.reference();

    DataSnapshot snapshot = await dbRef.child('Teachers/$userId').get();
    if (snapshot.value != null) {
      return 'Teacher';
    }

    snapshot = await dbRef.child('Students/$userId').get();
    if (snapshot.value is Map<dynamic, dynamic>) {
      final Map<dynamic, dynamic> valueMap = snapshot.value as Map<dynamic, dynamic>;
      final Map<String, dynamic> valueMapString = valueMap.map((key, value) => MapEntry(key.toString(), value));
      var accept = valueMapString['accept'] ?? false;
      if (accept) {
        return 'Student';
      }
      else {
        return 'NotAccept';
      }
    }

    return 'Unknown';
  }

  Future<void> _login(BuildContext context) async {
    try {
      // Perform login
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the userId from the UserCredential
      final userId = userCredential.user!.uid;

      // Determine user role
      final userRole = await getUserRole(userId);

      if (userRole == 'Teacher') {
        // Navigate to the Teacher page
        Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherHomePage()));
      } else if (userRole == 'Student') {
        // Navigate to the Student page (MyHomePage in your case)
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
      else if (userRole == 'NotAccept') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error"),
            content: Text("Techer not accept yet."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
      else {
        // Handle unknown role or show error
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error"),
            content: Text("User role is unknown."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle login error
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Login Failed"),
          content: Text(e.message ?? "Unknown error"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
              ),
              Text(
                'Welcome Back',
                style: titleText,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'New to this app?',
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
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: kDefaultPadding,
                child: LogInForm(
                  emailController: _emailController, // Passed to SignUpForm
                  passwordController: _passwordController, // Passed to SignUpForm
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()));
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kZambeziColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              PrimaryButton(buttonText: 'Log In', onPressed: () => _login(context)),
              SizedBox(
                height: 20,
              ),
              Text(
                'Or log in with:',
                style: subTitle.copyWith(color: kBlackColor),
              ),
              SizedBox(
                height: 20,
              ),
              LoginOption(),
            ],
          ),
        ),
      ),
    );
  }
}
