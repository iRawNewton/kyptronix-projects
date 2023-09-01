import 'package:client_onboarding_app/screens/dashboard/admin/admindash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyAdminLogin extends StatefulWidget {
  const MyAdminLogin({super.key});

  @override
  State<MyAdminLogin> createState() => _MyAdminLoginState();
}

class _MyAdminLoginState extends State<MyAdminLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      goToNext() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyAdminDash()));
      }

      goToNext();
    } catch (e) {
      if (e == 'user-not-found') {
      } else if (e == 'wrong-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text(
                  'Wrong Password',
                  style: TextStyle(fontFamily: 'fontOne'),
                ),
                content: Text(
                  'Please try again',
                  style: TextStyle(fontFamily: 'fontTwo'),
                ),
                icon: Icon(
                  Icons.warning_rounded,
                  size: 60,
                  color: Colors.red,
                ),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text(
                  'Wrong Password',
                  style: TextStyle(fontFamily: 'fontOne'),
                ),
                content: Text(
                  'Please try again',
                  style: TextStyle(fontFamily: 'fontTwo'),
                ),
                icon: Icon(
                  Icons.warning_rounded,
                  size: 60,
                  color: Colors.red,
                ),
              );
            });
      }
    }
  }

  forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: LottieBuilder.asset(
                        'assets/animations/admin_login.json'),
                  ),
                  const Text(
                    'Login to continue',
                    style: TextStyle(
                      fontFamily: 'fontOne',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.black87,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: [
                        // logo
                        const SizedBox(height: 50),
                        // email field
                        TextField(
                          controller: email,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Email id',
                            hintText: 'admin@gmail.com',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        // password field
                        const SizedBox(height: 30),
                        TextField(
                          controller: password,
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '*********',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        // button
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              email.text == 'kyptronix@gmail.com'
                                  ? login()
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          title: Text(
                                            'Invalid Email',
                                            style: TextStyle(
                                                fontFamily: 'fontOne'),
                                          ),
                                          content: Text(
                                            'Please use valid email id to continue',
                                            style: TextStyle(
                                                fontFamily: 'fontTwo'),
                                          ),
                                          icon: Icon(
                                            Icons.warning_rounded,
                                            size: 60,
                                            color: Colors.red,
                                          ),
                                        );
                                      });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade200),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'fontThree',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        // forgot password text
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                resetPassword() {
                                  FirebaseAuth.instance.sendPasswordResetEmail(
                                      email: email.text.trim());
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          title: Text(
                                            'Reset Link Sent',
                                            style: TextStyle(
                                                fontFamily: 'fontOne'),
                                          ),
                                          content: Text(
                                            'Please check your email to reset the password',
                                            style: TextStyle(
                                                fontFamily: 'fontTwo'),
                                          ),
                                          icon: Icon(
                                            Icons.info_rounded,
                                            size: 60,
                                            color: Colors.blue,
                                          ),
                                        );
                                      });
                                }

                                wrongEmailId() {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          title: Text(
                                            'Invalid Email',
                                            style: TextStyle(
                                                fontFamily: 'fontOne'),
                                          ),
                                          content: Text(
                                            'Please use valid email id to continue',
                                            style: TextStyle(
                                                fontFamily: 'fontTwo'),
                                          ),
                                          icon: Icon(
                                            Icons.warning_rounded,
                                            size: 60,
                                            color: Colors.red,
                                          ),
                                        );
                                      });
                                }

                                email.text == 'kyptronix@gmail.com'
                                    ? resetPassword()
                                    : wrongEmailId();
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontFamily: 'fontThree',
                                    color: Colors.indigo),
                              )),
                        )
                      ],
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
