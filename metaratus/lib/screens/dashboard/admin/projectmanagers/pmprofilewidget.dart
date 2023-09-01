import 'package:flutter/material.dart';

class PmProfileWidget extends StatefulWidget {
  const PmProfileWidget({
    super.key,
    required this.icon,
    required this.number,
    required this.text,
    required this.color,
  });
  final IconData icon;
  final String number;
  final String text;
  final Color color;
  @override
  State<PmProfileWidget> createState() => _PmProfileWidgetState();
}

class _PmProfileWidgetState extends State<PmProfileWidget> {
  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.width;
    var y = MediaQuery.of(context).size.height;
    return Card(
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: y,
          width: x * 0.40,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: x / 10,
                        ),
                        SizedBox(width: x / 20),
                        Text(
                          widget.number,
                          style: TextStyle(
                            fontFamily: 'fontOne',
                            fontSize: x * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontFamily: 'fontOne',
                      fontSize: x * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
