import 'package:flutter/material.dart';
import 'package:pre_school/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed; // Use VoidCallback for functions that return void

  // Update constructor to include required onPressed parameter
  PrimaryButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell( // Use InkWell for a material design ink effect on tap
      onTap: onPressed, // Execute the onPressed function when the button is tapped
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: kPrimaryColor),
        child: Text(
          buttonText,
          style: textButton.copyWith(color: kWhiteColor),
        ),
      ),
    );
  }
}
