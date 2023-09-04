import 'dart:convert';

import 'package:client_onboarding_app/screens/dashboard/developer/email/uiFolder/app_dev.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/uiFolder/dmedev.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/uiFolder/seodev.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/uiFolder/smodev.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../constant/string_file.dart';
import 'email/uiFolder/graphicsdev.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyDevEmailScreen extends StatefulWidget {
  const MyDevEmailScreen({super.key});

  @override
  State<MyDevEmailScreen> createState() => _MyDevEmailScreenState();
}

class _MyDevEmailScreenState extends State<MyDevEmailScreen> {
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
      appBar: AppBar(
        backgroundColor: Colors.amber.shade50,
        centerTitle: true,
        title: const Text(
          'Email',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.amber.shade50,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: isVisible
            ? (data[0]['cli_designation'] == 'Developer')
                ? EmailDev(
                    devId: devID,
                    devName: data[0]['cli_name'],
                    email: data[0]['cli_email'],
                    emailPass: data[0]['email_password'],
                  )
                : (data[0]['cli_designation'] == 'Graphic Designer')
                    ? GraphicsDev(
                        devId: devID,
                        devName: data[0]['cli_name'],
                        email: data[0]['cli_email'],
                        emailPass: data[0]['email_password'],
                      )
                    : (data[0]['cli_designation'] == 'SMO'
                        ? SmoDev(
                            devId: devID,
                            devName: data[0]['cli_name'],
                            email: data[0]['cli_email'],
                            emailPass: data[0]['email_password'],
                          )
                        : (data[0]['cli_designation'] ==
                                'Digital Marketing Expert')
                            ? DmeDev(
                                devId: devID,
                                devName: data[0]['cli_name'],
                                email: data[0]['cli_email'],
                                emailPass: data[0]['email_password'],
                              )
                            : SeoDev(
                                devId: devID,
                                devName: data[0]['cli_name'],
                                email: data[0]['cli_email'],
                                emailPass: data[0]['email_password'],
                              ))
            : const Center(
                child: Text(
                'Please wait loading...',
                style: TextStyle(fontFamily: 'fontThree'),
              )),
      ),
    );
  }
}
