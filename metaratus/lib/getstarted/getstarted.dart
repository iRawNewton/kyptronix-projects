import 'package:client_onboarding_app/screens/2selectuser/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppGetStarted extends StatefulWidget {
  const MyAppGetStarted({super.key});

  @override
  State<MyAppGetStarted> createState() => _MyAppGetStartedState();
}

class _MyAppGetStartedState extends State<MyAppGetStarted> {
  @override
  void initState() {
    // getDeviceState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // image: AssetImage("assets/images/background.png"),
                image: AssetImage("assets/images/bg1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Lottie.asset('assets/animations/GetStarted.json'),
                ),
                const Text(
                  'See your Project Status with\nMetaratus',
                  style: TextStyle(
                    fontFamily: 'fontOne',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Our platform gives you an up-to-date view of\nyour project status so you can stay on top of things.',
                    style: TextStyle(
                        fontFamily: 'fontThree',
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(5),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue.shade50)),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showGetStarted', false);
                          goTo() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyUsers(),
                              ),
                            );
                          }

                          goTo();
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                            fontFamily: 'fontTwo',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Text(tempID),
                // ElevatedButton(
                //   onPressed: () {
                //     sendNotificationToUser();
                //   },
                //   child: Text('click for notifications'),
                // ),
              ],
            )),
      ),
    );
  }
}
