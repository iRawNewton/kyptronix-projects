import 'dart:async';
import 'dart:convert';
import 'package:client_onboarding_app/screens/navigation/developer/dev_navigation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/methods/methods.dart';
import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyDevLogin extends StatefulWidget {
  const MyDevLogin({super.key});

  @override
  State<MyDevLogin> createState() => _MyDevLoginState();
}

class _MyDevLoginState extends State<MyDevLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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

  devLoginFunc(emailText, passwordText, context) async {
    Map<String, String> bodyParameter = {
      'cli_username': emailController.text,
      'cli_password': passwordController.text,
    };
    // update notify
    await http
        .post(Uri.parse('$tempUrl/notification/updateNotification.php'), body: {
      'device_id': deviceId.text,
      'email_id': emailController.text,
    });
    // login func
    var response = await http.post(Uri.parse('$tempUrl/login/devLogin.php'),
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
      if (data[0]['cli_email'].toLowerCase() ==
              emailController.text.toLowerCase() &&
          data[0]['cli_password'] == passwordController.text) {
        logIn(emailController.text, passwordController.text);
        Timer(const Duration(seconds: 1), () {});
        emailController.clear();
        passwordController.clear();
        // shared prefs
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("devId", data[0]['id']);
        pref.setString("devname", data[0]['cli_username']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyDevNav(),
          ),
        );
        setState(() {
          isNotLoading = true;
        });
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
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      if (changes.to.status == OSNotificationPermission.authorized) {
        // User has fully authorized push permissions
        getDeviceState();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                        child: Lottie.asset('assets/animations/dev.json'),
                      ),

                      // Welcome
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome Developer',
                          style: TextStyle(
                              fontFamily: 'fontOne',
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      // title
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login to continue',
                          style: TextStyle(
                              fontFamily: 'fontOne',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
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
                              controller: emailController,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
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
                              obscureText: obscureText,
                              controller: passwordController,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
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
                              ),
                            ),
                          ),
                        ),
                      ),
                      // forgot password
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     child: const Text('Forgot Password?'),
                      //   ),
                      // ),
                      // login
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        height: 50,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (emailController.text != '' &&
                                  passwordController.text != '') {
                                setState(() {
                                  isNotLoading = false;
                                });
                                devLoginFunc(emailController,
                                    passwordController, context);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.blue.shade200)),
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
