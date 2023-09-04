import 'dart:async';
import 'dart:convert';
import 'package:client_onboarding_app/chat/methods/methods.dart';
import 'package:client_onboarding_app/screens/dashboard/client/client_dash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyClientLogin extends StatefulWidget {
  const MyClientLogin({super.key});

  @override
  State<MyClientLogin> createState() => _MyClientLoginState();
}

class _MyClientLoginState extends State<MyClientLogin> {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final deviceId = TextEditingController();
  bool isNotLoading = true;
  bool obscureText = true;

  // get device ID
  void getDeviceState() async {
    var status = await OneSignal.shared.getDeviceState();
    var playerId = status!.userId;
    setState(() {
      deviceId.text = playerId!;
    });
  }

  cliLoginFunc(emailText, passwordText, context) async {
    // update notify
    await http
        .post(Uri.parse('$tempUrl/notification/updateNotification.php'), body: {
      'device_id': deviceId.text,
      'email_id': emailText.text,
    });

    // login func
    Map<String, String> bodyParameter = {
      'cli_userid': emailText.text,
      'cli_pass': passwordText.text,
    };
    var response = await http.post(Uri.parse('$tempUrl/login/cliLogin.php'),
        body: bodyParameter);

    if (response.body == 'Found Nothing') {
      setState(() {
        isNotLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    } else {
      List data = jsonDecode(response.body);
      if (data[0]['cli_email'].toLowerCase() == emailText.text.toLowerCase() &&
          data[0]['cli_pass'] == passwordText.text) {
        logIn(emailText.text, passwordText.text);

        Timer(
          const Duration(seconds: 1),
          () async {
            // shared prefs
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("cliId", data[0]['id']);
            pref.setString("cliname", data[0]['cli_name']);
            setState(() {
              isNotLoading = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyClientDashboard(),
              ),
            );
          },
        );

        emailText.clear();
        passwordText.clear();

        // snackbar
      } else {
        setState(() {
          isNotLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.yellow,
            content: Text('An error occured. Please report to Dev!'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    getDeviceState();
    super.initState();
  }

  @override
  void dispose() {
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isNotLoading
            ? Container(
                height: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.47,
                        child: Lottie.asset('assets/animations/client.json'),
                      ),

                      // Welcome
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome client',
                          style: TextStyle(
                            fontFamily: 'fontOne',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // title
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login to continue',
                          style: TextStyle(
                            fontFamily: 'fontOne',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60.0),
                      // username
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              controller: emailText,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              controller: passwordText,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon: Icon(obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // login button
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.75,
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (emailText.text != '' &&
                                passwordText.text != '') {
                              setState(() {
                                isNotLoading = false;
                              });
                              cliLoginFunc(emailText, passwordText, context);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.amber.shade200)),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'fontFive',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child:
                        LottieBuilder.asset('assets/animations/loading.json')),
              ),
      ),
    );
  }
}
