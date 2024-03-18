import 'package:flutter/material.dart';
import 'package:pre_school/theme.dart';

class CheckBox extends StatefulWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CheckBox(this.text, {Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // When the container is tapped, we invert the current value
                // and notify the parent widget about the change.
                widget.onChanged(!widget.value);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: kDarkGreyColor)),
                child: widget.value
                    ? Icon(
                  Icons.check,
                  size: 17,
                  color: Colors.green,
                )
                    : null,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(widget.text),
          ],
        )
      ],
    );
  }
}
