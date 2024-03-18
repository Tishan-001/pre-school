import 'package:flutter/material.dart';
import 'package:pre_school/theme.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController conformpasswordController;
  final TextEditingController phoneController;
  final TextEditingController fistNameController;
  final TextEditingController lastNameController;

  SignUpForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.fistNameController,
    required this.lastNameController,
    required this.conformpasswordController,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('First Name', false, widget.fistNameController),
        buildInputForm('Last Name', false, widget.lastNameController),
        buildInputForm('Email', false, widget.emailController), // Updated
        buildInputForm('Phone', false, widget.phoneController),
        buildInputForm('Password', true, widget.passwordController), // Updated
        buildInputForm('Confirm Password', true, widget.conformpasswordController),
      ],
    );
  }

  Padding buildInputForm(String hint, bool pass, TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          controller: controller,
          obscureText: pass ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kTextFieldColor),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            suffixIcon: pass
                ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon: _isObscure
                    ? Icon(
                  Icons.visibility_off,
                  color: kTextFieldColor,
                )
                    : Icon(
                  Icons.visibility,
                  color: kPrimaryColor,
                ))
                : null,
          ),
        ));
  }
}
