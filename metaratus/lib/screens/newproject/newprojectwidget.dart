import 'package:flutter/material.dart';

class MyNewProjectWidget extends StatefulWidget {
  const MyNewProjectWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.enabled});
  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  @override
  State<MyNewProjectWidget> createState() => _MyNewProjectWidgetState();
}

class _MyNewProjectWidgetState extends State<MyNewProjectWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          enabled: widget.enabled,
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
