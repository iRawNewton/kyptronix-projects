import 'package:flutter/material.dart';

import '../dashboard/client/colorwidget.dart';

class MySalesWidget extends StatefulWidget {
  const MySalesWidget({super.key, required this.text});
  final String text;
  @override
  State<MySalesWidget> createState() => _MySalesWidgetState();
}

class _MySalesWidgetState extends State<MySalesWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'fontTwo',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: MyColor.primaryText,
        ),
      ),
    );
  }
}
