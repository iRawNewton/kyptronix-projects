import 'package:client_onboarding_app/getstarted/getstarted.dart';
import 'package:client_onboarding_app/screens/2selectuser/homescreen.dart';
import 'package:client_onboarding_app/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  // one signal
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId('72ce8522-61ad-427a-a911-69165ea330b6');
  OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
    debugPrint('accepted permission: $value');
  });
  final prefs = await SharedPreferences.getInstance();
  final showGetStarted = prefs.getBool('showGetStarted') ?? true;
  runApp(MyApp(showGetStarted: showGetStarted));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.showGetStarted});
  final bool showGetStarted;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // for splash screen
    void initialize() async {
      await Future.delayed(const Duration(seconds: 2));
      FlutterNativeSplash.remove();
    }

    initialize();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metaratus Mobile App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      // home: showGetStarted ? const MyAppGetStarted() : const MyUsers(),
      // home: AnimatedSplashScreen(
      //   splash: 'assets/images/SplashScreen.png',
      //   nextScreen:
      //       showGetStarted ? const MyAppGetStarted() : const MyUsers(),
      //   splashTransition: SplashTransition.rotationTransition,
      //   pageTransitionType: PageTransitionType.rightToLeft,
      // )
      home: SplashScreen(showGetStarted: showGetStarted),
    );
  }
}
