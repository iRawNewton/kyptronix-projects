import 'dart:convert';
import 'package:client_onboarding_app/screens/assignproject/developer/questionaire/question_dev.dart';
import 'package:client_onboarding_app/screens/assignproject/developer/questionaire/question_seo.dart';
import 'package:client_onboarding_app/screens/assignproject/developer/questionaire/question_smo.dart';
import 'package:client_onboarding_app/screens/assignproject/developer/questionaire/question_default.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class AuthQuestionaire extends StatefulWidget {
  const AuthQuestionaire({super.key, required this.developerIdTemp});
  final String developerIdTemp;

  @override
  State<AuthQuestionaire> createState() => _AuthQuestionaireState();
}

class _AuthQuestionaireState extends State<AuthQuestionaire> {
  dynamic data;
  String devID = '';
  bool isVisible = false;

  // Future getDevName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? developerID = prefs.getString('devId');

  //   setState(() {
  //     devID = developerID.toString();
  //   });
  // }

  getProjID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    setState(() {
      devID = developerID.toString();
    });

    // String? name = prefs.getString('cliname');

    var response =
        await http.post(Uri.parse('$tempUrl/dev/getSpecificDev.php'), body: {
      'searchValue': devID,
    });

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        isVisible = true;
      });
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  void initState() {
    getProjID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightBlue.shade50,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: isVisible
            ? (data[0]['cli_designation'] == 'Developer')
                ? QuestionDev(id: widget.developerIdTemp)
                : (data[0]['cli_designation'] == 'Graphic Designer')
                    ? const QuestionDefault()
                    : (data[0]['cli_designation'] == 'SMO')
                        ? QuestionSmo(id: widget.developerIdTemp)
                        : (data[0]['cli_designation'] ==
                                'Digital Marketing Expert')
                            ? const QuestionDefault()
                            : QuestionSeo(id: widget.developerIdTemp)
            : const Center(
                child: Text(
                'Please wait loading...',
                style: TextStyle(fontFamily: 'fontThree'),
              )),
      ),
    );
  }
}
