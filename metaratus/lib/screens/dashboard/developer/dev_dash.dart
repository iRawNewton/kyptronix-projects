import 'dart:async';
import 'dart:convert';

import 'package:client_onboarding_app/notification/event_notification.dart';
import 'package:client_onboarding_app/notification/notificationui/notificationui.dart';
import 'package:client_onboarding_app/screens/2selectuser/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:jumping_dot/jumping_dot.dart';

import '../../../chat/groupchat/devgroupchatfun.dart';
import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyDevDashboard extends StatefulWidget {
  const MyDevDashboard({super.key});

  @override
  State<MyDevDashboard> createState() => _MyDevDashboardState();
}

class _MyDevDashboardState extends State<MyDevDashboard> {
  Future<void> sendNotificationToUser(String title, String content) async {
    // create a notification with the given player ID as the target
    var notification = OSCreateNotification(
      playerIds: ['95522be7-c98c-4838-94d5-6bdf379fb7a5'],
      content: 'No content', // content
      heading: 'Test Title', // title
      androidSound: 'iphone_sound',
      androidChannelId: '38aa8271-8a48-4936-8ca6-a6f1d0b674f9',
      additionalData: {'category': 'KyptronixDemo'},
      androidSmallIcon: 'https://kyptronix.us/images/webp/logo.webp',
      androidLargeIcon: 'https://kyptronix.us/images/webp/logo.webp',
    );

    await OneSignal.shared.postNotification(notification);
  }

  // delete shared prefs
  Future deleteSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('devId');
  }

  TextEditingController dateController = TextEditingController();
  TextEditingController taskDone = TextEditingController();
  TextEditingController projectID = TextEditingController();
  TextEditingController progressIndicator = TextEditingController();
  TextEditingController projectLink = TextEditingController();

  DateTime selectedDate = DateTime.now();
  double progressValue = 0;
  bool isVisibleButton = true;
  String devName = '';
  String devID = '';
  List projectList = [];
  bool chatLoader = false;
  String? dropdownvalue1;
  dynamic data;
  List deviceId = [];
  List projectName = [];
  String projName = '';
  String cliId = '';
  String pmId = '';
  bool loadingIndicator = true;
  String notiNumber = '';
  Timer? _timer;

  void datePickerFunction(dateController) {
    var initialDate = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    dateController.text = formatter.format(initialDate);
  }

  Future getDevName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    var developerName = prefs.getString('devname');
    setState(() {
      devName = developerName!;
      devID = developerID.toString();
    });
  }

  Future getProjID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    String devID = developerID.toString();

    var response = await http
        .post(Uri.parse('$tempUrl/project/getProjectNames.php'), body: {
      'proj_dev_id': devID.toString(),
    });

    var notiCounter = await http.post(
        Uri.parse('$tempUrl/notification/notificationCounter.php'),
        body: {
          'proj_dev_id': devID.toString(),
        });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      setState(() {
        projectList = jsonData;
      });
    } else {}

    if (notiCounter.statusCode == 200) {
      var jsonData1 = jsonDecode(notiCounter.body);

      setState(() {
        notiNumber = jsonData1[0]['count'].toString();
      });
    } else {}
  }

  postData(context) async {
    var responseNotificationDeviceID = await http.post(
        Uri.parse('$tempUrl/notification/notificationForRemark.php'),
        body: {
          'project_id': projectID.text,
        });

    var responseNotificationProjectName = await http.post(
        Uri.parse('$tempUrl/notification/getProjectNameForNotification.php'),
        body: {
          'project_id': projectID.text,
        });

    if (responseNotificationDeviceID.statusCode == 200) {
      setState(() {
        deviceId = jsonDecode(responseNotificationDeviceID.body);
      });
    }

    if (responseNotificationProjectName.statusCode == 200) {
      setState(() {
        projectName = jsonDecode(responseNotificationProjectName.body);
        projName = projectName[0]['proj_name'];
        cliId = projectName[0]['proj_cli_id'].toString();
        pmId = projectName[0]['proj_pm_id'].toString();
      });
    }
    sendCustomNotificationToUser(
        context,
        'Project remarks updated',
        '$devName added remarks in ${projectName[0]['proj_name']}',
        deviceId[0]['device_id']);

    var response =
        await http.post(Uri.parse('$tempUrl/updatetask/dailytask.php'), body: {
      'cli_date': dateController.text,
      'cli_task': taskDone.text,
      'cli_progress': progressIndicator.text,
      'cli_devid': devID,
      'cli_projid': projectID.text,
      'remarks_by': 'dev',
      'proj_links': projectLink.text,
      'proj_name': projName,
      'cliId': cliId,
      'pmId': pmId,
    });

    if (response.statusCode == 200) {
      taskDone.clear();
      projectLink.clear();
      setState(() {
        loadingIndicator = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Success!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    }
  }

  // *****************************
  startUpdatingData() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getProjID();
    });
  }

  @override
  void initState() {
    getProjID();
    getDevName();
    startUpdatingData();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to stop continuous updates
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade50,
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontFamily: 'fontOne', fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 2,
        actions: [
          Stack(
            children: [
              Positioned(
                  right: 10,
                  top: 5,
                  child: Text(
                    notiNumber,
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontFamily: 'fontThree',
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyNotificationUi(
                                userid: devID,
                                user: 'Dev',
                              )));
                },
                icon: const Icon(Icons.notifications),
                color: Colors.black87,
              ),
            ],
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const MyUsers();
                  },
                ),
              );

              Future<void> signOut() async {
                final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                await firebaseAuth.signOut();
              }

              signOut();

              // deleteSharedPrefs();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("devId", '');
              prefs.setString("devname", '');
            },
            icon: const Icon(Icons.logout_rounded),
            color: Colors.black,
          )
        ],
      ),
      body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
          ),
          child: loadingIndicator
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // hi
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hi,',
                          style: TextStyle(
                              fontFamily: 'fontOne',
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // user name
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          devName,
                          style: const TextStyle(
                              fontFamily: 'fontOne',
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      // date
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          keyboardType: TextInputType.none,
                          controller: dateController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Working Date',
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 0, 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'fontTwo',
                          ),
                          onTap: () {
                            datePickerFunction(dateController);
                          },
                        ),
                      ),

                      // project ID
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: DropdownButton(
                              underline: const SizedBox(),
                              dropdownColor: Colors.blue.shade100,
                              isExpanded: true,
                              hint: const Text('Project Title'),
                              items: projectList.map((item) {
                                return DropdownMenuItem(
                                  value: item['id'].toString(),
                                  child: Text(item['proj_name'].toString()),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  dropdownvalue1 = newVal;
                                  projectID.text = newVal!;
                                });
                              },
                              value: dropdownvalue1,
                            ),
                          ),
                        ),
                      ),

                      // tasks done
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              controller: taskDone,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Task Done',
                              ),
                            ),
                          ),
                        ),
                      ),

                      // project link
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              controller: projectLink,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Project Link',
                              ),
                            ),
                          ),
                        ),
                      ),

                      // progress indicator
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Progress Indicator',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 2),
                      StepProgressIndicator(
                        totalSteps: 100,
                        currentStep: progressValue.toInt(),
                        size: 50,
                        padding: 0,
                        // selectedColor: Colors.greenAccent.shade700,
                        // unselectedColor: Colors.red,
                        roundedEdges: const Radius.circular(10),
                        selectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.greenAccent.shade700, Colors.green],
                        ),
                        unselectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.blue.shade100],
                        ),
                      ),
                      // *************
                      const SizedBox(height: 10.0),
                      // slider
                      Slider(
                        inactiveColor: Colors.white,
                        activeColor: const Color(0xffFDA615),
                        value: progressValue,
                        min: 0.0,
                        max: 99.0,
                        divisions: 100,
                        onChanged: (double value) {
                          setState(() {
                            progressValue = value;
                            progressIndicator.text = progressValue.toString();
                          });
                        },
                        label: progressValue.toInt().toString(),
                      ),
                      const SizedBox(height: 40.0),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loadingIndicator = false;
                            });
                            postData(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.green.shade800)),
                          child: const Text(
                            'Modify',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )
              : Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: LottieBuilder.asset(
                          'assets/animations/loading.json')),
                )),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue.shade100,
      //   onPressed: () {
      //     setState(() {
      //       chatLoader = true;
      //     });
      //     getEmailId(context);
      //     Future.delayed(const Duration(seconds: 5), () {
      //       setState(() {
      //         chatLoader = false;
      //       });
      //     });
      //   },
      //   child: chatLoader
      //       ? JumpingDots(
      //           color: Colors.black,
      //           radius: 5,
      //           numberOfDots: 3,
      //           animationDuration: const Duration(milliseconds: 400),
      //         )
      //       : const Icon(Icons.chat_bubble_outline_rounded),
      // ),
    );
  }
}
