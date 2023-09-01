import 'package:client_onboarding_app/screens/3loginpage/admin/adminlogin.dart';
import 'package:client_onboarding_app/screens/3loginpage/developer/login.dart';
import 'package:client_onboarding_app/screens/3loginpage/client/login.dart';
import 'package:client_onboarding_app/screens/3loginpage/pm/login.dart';
import 'package:client_onboarding_app/screens/dashboard/client/client_dash.dart';
import 'package:client_onboarding_app/screens/dashboard/pm/pm_dashboard.dart';
import 'package:client_onboarding_app/screens/navigation/developer/dev_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

var checkDevId = '';
var clientID = '';
var pmId = '';

class MyUsers extends StatefulWidget {
  const MyUsers({super.key});

  @override
  State<MyUsers> createState() => _MyUsersState();
}

class _MyUsersState extends State<MyUsers> {
  // shared prefs for dev
  Future devValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var pmid = sharedPreferences.getString('pmId');
    var developerId = sharedPreferences.getString('devId');
    var clientId = sharedPreferences.getString('cliId');

    setState(() {
      pmId = (pmid == null) ? '' : pmid;
      checkDevId = (developerId == null) ? '' : developerId;
      clientID = (clientId == null) ? '' : clientId;
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.blue.shade100,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                // logo
                GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAdminLogin()));
                  },
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: x / 6,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                ),
                // choose your role
                const SizedBox(height: 0),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Choose Your Role',
                      style: TextStyle(
                          fontSize: x * 0.06,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'fontOne'),
                    )),
                // project manager
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    devValidationData().whenComplete(() async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pmId == ''
                                  ? const MyPmLogin()
                                  : const MyPmDashboard()));
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: x * 0.2, vertical: x * 0.03),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 10.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade200,
                            radius: 50.0,
                            child: Lottie.asset('assets/animations/pm.json'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Project Manager',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: x * 0.045,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'fontTwo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // client
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    devValidationData().whenComplete(() async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => clientID == ''
                                  ? const MyClientLogin()
                                  : const MyClientDashboard()));
                    });

                    // print(clientID);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: x * 0.2, vertical: x * 0.03),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 10.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade200,
                            radius: 50.0,
                            child:
                                Lottie.asset('assets/animations/client.json'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Client',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: x * 0.045,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'fontTwo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // developer
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    devValidationData().whenComplete(() async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => checkDevId == ''
                                  ? const MyDevLogin()
                                  : const MyDevNav()));
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: x * 0.2, vertical: x * 0.03),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 10.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade200,
                            radius: 50.0,
                            child: Lottie.asset('assets/animations/dev.json'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Development Team',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: x * 0.045,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'fontTwo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
