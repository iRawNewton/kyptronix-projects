import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class QuestionDefault extends StatefulWidget {
  const QuestionDefault({super.key});

  @override
  State<QuestionDefault> createState() => _QuestionDefaultState();
}

class _QuestionDefaultState extends State<QuestionDefault> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Questionaire Form',
            style: TextStyle(
              fontFamily: 'fontOne',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade50,
        ),
        body: LottieBuilder.asset('assets/animations/nodata_available.json'));
  }
}
