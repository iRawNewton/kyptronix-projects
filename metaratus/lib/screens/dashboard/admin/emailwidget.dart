import 'package:flutter/material.dart';

class EmailWidget extends StatefulWidget {
  const EmailWidget({
    super.key,
    required this.labelText,
    required this.controller,
    required this.textInputType,
    required this.textLines,
  });
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final int? textLines;

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.labelText,
                style: const TextStyle(
                    fontFamily: 'fontThree',
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  controller: widget.controller,
                  keyboardType: widget.textInputType,
                  maxLines: widget.textLines,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
