import 'package:flutter/material.dart';

class MyDevEmailWidget extends StatefulWidget {
  const MyDevEmailWidget(
      {super.key,
      required this.hintText,
      required this.infoText,
      required this.controller});

  final String hintText;
  final String infoText;
  final TextEditingController controller;

  @override
  State<MyDevEmailWidget> createState() => _MyDevEmailWidgetState();
}

class _MyDevEmailWidgetState extends State<MyDevEmailWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: widget.controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    fontFamily: 'fontTwo',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.indigo, size: 18),
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Dismiss',
              barrierColor: Colors.black.withOpacity(0.5),
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.infoText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'fontOne',
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class MyDevEmailTextfield extends StatefulWidget {
  const MyDevEmailTextfield(
      {super.key, required this.hintText, required this.controller});
  final String hintText;
  final TextEditingController controller;

  @override
  State<MyDevEmailTextfield> createState() => _MyDevEmailTextfieldState();
}

class _MyDevEmailTextfieldState extends State<MyDevEmailTextfield> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: widget.controller,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'fontTwo',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
