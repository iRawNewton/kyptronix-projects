import 'dart:async';
import 'dart:convert';
import 'package:client_onboarding_app/chat/chatlist/chatlist.dart';
import 'package:client_onboarding_app/screens/dashboard/pm/changedev.dart';
import 'package:client_onboarding_app/screens/dashboard/pm/payments/paymentform.dart';
import 'package:client_onboarding_app/screens/dashboard/pm/pm_dash_popup.dart';
import 'package:client_onboarding_app/screens/dashboard/pm/questionaire.dart';
import 'package:client_onboarding_app/screens/dashboard/pm/remarksform.dart';
import 'package:client_onboarding_app/screens/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../chat/methods/methods.dart';
import '../../../constant/string_file.dart';
import '../../../notification/notificationui/notificationui.dart';
import '../../2selectuser/homescreen.dart';
import 'package:http/http.dart' as http;

import '../client/colorwidget.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyPmDashboard extends StatefulWidget {
  const MyPmDashboard({super.key});

  @override
  State<MyPmDashboard> createState() => _MyPmDashboardState();
}

class _MyPmDashboardState extends State<MyPmDashboard> {
  final TextEditingController remarksText = TextEditingController();
  final TextEditingController linkText = TextEditingController();
  final TextEditingController projName = TextEditingController();
  String pmId = '';
  String pmName = '';
  bool isVisible = true;
  IconData isCheck = Icons.radio_button_unchecked;
  dynamic complete;
  dynamic ongoing;
  dynamic pending;
  dynamic cancelled;
  dynamic extendedStatsTotal;
  dynamic extendedStatsBalance;
  bool isNotLoading = true;
  bool showRecord = false;
  bool showRemarks = true;
  bool showRemarksLoading = true;
  Timer? timer;
  // for chat
  late Map<String, dynamic> userMap;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // future method
  late Future getFutureMethod;

  Stream<Object?>? getFutureMethodforModal;
  var testVariable = '';

  // for remarks
  dynamic remarksData;
  String notiNumber = '';

  Future<void> getPmName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var pmNAME = prefs.getString('pmname');

    if (mounted) {
      setState(() {
        pmId = pmID.toString();
        pmName = pmNAME!;
      });
    }

    var notiCounter = await http.post(
      Uri.parse('$tempUrl/notification/notificationCounterPm.php'),
      body: {
        'proj_pm_id': pmId,
      },
    );

    if (mounted && notiCounter.statusCode == 200) {
      var jsonData1 = jsonDecode(notiCounter.body);

      setState(() {
        notiNumber = jsonData1.length.toString();
      });
    }
  }

// onStatsClick

  getOnComplete() async {
    var response = await http.post(
      Uri.parse('$tempUrl/projectmanager/dashboard/getOnComplete.php'),
      body: {
        'pm_id': pmId,
      },
    );
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);

        setState(() {
          isNotLoading = true;
          showRecord = true;
          // currentUsername = data[0]['cli_userid'];
          // clientName = name.toString();
        });
      } else {
        setState(() {
          isNotLoading = true;
          showRecord = false;
        });
      }
    }
  }

  getOnGoing() async {
    var response = await http.post(
      Uri.parse('$tempUrl/projectmanager/dashboard/getOnGoing.php'),
      body: {
        'pm_id': pmId,
      },
    );
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          isNotLoading = true;
          showRecord = true;
        });
      } else {
        setState(() {
          isNotLoading = true;
          showRecord = false;
        });
      }
    }
  }

  getOnPending() async {
    var response = await http.post(
      Uri.parse('$tempUrl/projectmanager/dashboard/getOnPending.php'),
      body: {
        'pm_id': pmId,
      },
    );

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          isNotLoading = true;
          showRecord = true;
        });
      } else {
        setState(() {
          isNotLoading = true;
          showRecord = false;
        });
      }
    }
  }

  getOnCancelled() async {
    setState(() {
      isNotLoading = true;
      showRecord = false;
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  dynamic data = [];

  Future<void> getProjectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var pmNAME = prefs.getString('pmname');
    setState(() {
      pmId = pmID.toString();
      pmName = pmNAME!;
    });

    var response = await http.post(
      Uri.parse('$tempUrl/project/getEntireProjectList.php'),
      body: {
        'pm_id': pmId,
      },
    );
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);

        setState(() {
          isNotLoading = true;
          showRecord = true;
        });
      } else {
        setState(() {
          isNotLoading = true;
          showRecord = false;
        });
      }
    }
  }

  Future<void> getProjectListNames(String projectName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var pmNAME = prefs.getString('pmname');
    setState(() {
      pmId = pmID.toString();
      pmName = pmNAME!;
    });

    var response = await http.post(
      Uri.parse('$tempUrl/project/getEntireProjectListName.php'),
      body: {
        'pm_id': pmId,
        'queryvalue': projectName,
      },
    );
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);

        setState(() {
          isNotLoading = true;
          showRecord = true;
        });
      } else {
        setState(() {
          isNotLoading = true;
          showRecord = false;
        });
      }
    }
  }

  Future projectComplete(id) async {
    await http.post(Uri.parse('$tempUrl/project/completeProject.php'), body: {
      'idValue': id.toString(),
    });
    refreshPage();
  }

  refreshPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyPmDashboard(),
      ),
    );
  }

  Future projectDiscard(id) async {
    await http.post(Uri.parse('$tempUrl/project/discardProject.php'), body: {
      'idValue': id.toString(),
    });
    refreshPage();
  }

  Future projectRemarks(id) async {
    await http.post(Uri.parse('$tempUrl/project/discardProject.php'), body: {
      'idValue': id.toString(),
    });
  }

// statistics
  Future onComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    String pmid = pmID.toString();

    var response =
        await http.post(Uri.parse('$tempUrl/project/onMComplete.php'), body: {
      'proj_pm_id': pmid,
    });
    if (response.statusCode == 200) {
      var icomplete = jsonDecode(response.body);
      setState(() {
        complete = icomplete[0]['complete'];
      });
    }
  }

  Future onGoing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    String pmid = pmID.toString();
    var response =
        await http.post(Uri.parse('$tempUrl/project/onMGoing.php'), body: {
      'proj_pm_id': pmid,
    });
    if (response.statusCode == 200) {
      var iongoing = jsonDecode(response.body);
      setState(() {
        ongoing = iongoing[0]['ongoing'];
      });
    }
  }

  Future onPending() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    String pmid = pmID.toString();
    var response =
        await http.post(Uri.parse('$tempUrl/project/onMPending.php'), body: {
      'proj_pm_id': pmid,
    });
    if (response.statusCode == 200) {
      var ionpending = jsonDecode(response.body);
      setState(() {
        pending = ionpending[0]['pending'];
      });
    }
  }

  Future onCollection() async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');

    var response = await http
        .post(Uri.parse('$tempUrl/payment/amountPaidStats.php'), body: {
      'currentDate': currentMonth.toString(),
      'proj_pm_id': pmID,
    });
    if (response.statusCode == 200) {
      var ioncancelled = jsonDecode(response.body);
      setState(() {
        cancelled = ioncancelled[0]['amtPaid'];
      });
    }
  }

  Future onExtendedStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var response = await http
        .post(Uri.parse('$tempUrl/payment/paymentStatsForDash.php'), body: {
      'proj_pm_id': pmID,
    });

    if (response.statusCode == 200) {
      var extendedStats = jsonDecode(response.body);
      setState(() {
        extendedStatsTotal = extendedStats[0]['totalAmt'];
        extendedStatsBalance = extendedStats[0]['totalBal'];
      });
    }
  }

  getRemarks(projectId) async {
    // for remarks
    var iresponse = await http.post(
        Uri.parse('$tempUrl/projectmanager/dashboard/getRemarks.php'),
        body: {
          'proj_id': projectId,
        });

    if (iresponse.statusCode == 200) {
      dynamic x = jsonDecode(iresponse.body);

      if (x.length == 0) {
        setState(() {
          showRemarksLoading = false;
          remarksData = [];
          showRemarks = false;
        });
      } else {
        setState(() {
          showRemarks = true;
          remarksData = x;
        });
      }
    }
  }

  deleteRemarks(id) async {
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/dashboard/deleteRemarks.php'),
        body: {
          'id': id.toString(),
        });
    if (response.statusCode == 200) {
    } else {}
  }

  @override
  void initState() {
    getPmName();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        getPmName();
      },
    );
    onComplete();
    onGoing();
    onPending();
    onCollection();
    getFutureMethod = getProjectList();
    onExtendedStats();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade100,
            title: const Text(
              'Home',
              style: TextStyle(
                fontFamily: 'fontOne',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
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
                                    userid: pmId,
                                    user: 'Pm',
                                  )));
                    },
                    icon: const Icon(Icons.notifications),
                    color: Colors.black87,
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  logOut(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const MyUsers();
                      },
                    ),
                  );
                  // deleteSharedPrefs();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("pmId", '');
                  prefs.setString("pmname", '');
                },
                icon: const Icon(Icons.logout),
                color: Colors.black,
              )
            ],
          ),
          body: isNotLoading
              ? Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // image: AssetImage("assets/images/background.png"),
                      image: AssetImage("assets/images/bg1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ElevatedButton(
                        //     onPressed: () {
                        //       sendCustomNotificationToUser(
                        //           context,
                        //           'New Project',
                        //           'A new project has been assigned to you.',
                        //           'bd5ef86c-9b6a-4bc5-b9d8-e8bb671916af');
                        //     },
                        //     child: Text('data')),
                        const SizedBox(height: 10.0),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                                fontFamily: 'fontOne',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pmName,
                            style: const TextStyle(
                                fontFamily: 'fontOne',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        // statstics
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 30.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isNotLoading = false;
                                        getFutureMethod = getOnComplete();
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: MyColor.totalCard,
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.check_box_outlined,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                complete.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Text(
                                                'Completed',
                                                style: TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isNotLoading = false;
                                        getFutureMethod = getOnGoing();
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: MyColor.ongoingCard,
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.insert_chart_outlined_rounded,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                ongoing.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Text(
                                                'Ongoing',
                                                style: TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isNotLoading = false;
                                        getFutureMethod = getOnPending();
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: MyColor.notstartedCard,
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.access_time_rounded,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                pending.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Text(
                                                'Pending',
                                                style: TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   isNotLoading = false;
                                      //   getFutureMethod = getOnCancelled();
                                      // });
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const CollectionForm();
                                          });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: MyColor.cancelCard,
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.payment_rounded,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                (cancelled == null)
                                                    ? '0'
                                                    : '\$ $cancelled',
                                                style: const TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Text(
                                                'Collections',
                                                style: TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PmDashPopUp(
                                          pmId: pmId, type: 'gross');
                                    });
                              },
                              child: Card(
                                color: MyColor.totalCard,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Gross: \$$extendedStatsTotal',
                                            style: const TextStyle(
                                              fontFamily: 'fontTwo',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // add pop up
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PmDashPopUp(
                                          pmId: pmId, type: 'pending');
                                    });
                              },
                              child: Card(
                                color: MyColor.notstartedCard,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Pending: \$$extendedStatsBalance',
                                            style: const TextStyle(
                                              fontFamily: 'fontTwo',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isNotLoading = false;
                                  getFutureMethod = getProjectList();
                                });
                              },
                              child: Text(
                                'All Projects',
                                style: TextStyle(
                                    fontFamily: 'fontTwo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: TextField(
                                      controller: projName,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isNotLoading = false;
                                        getFutureMethod =
                                            getProjectListNames(projName.text);
                                      });
                                    },
                                    child: const Text(
                                      'Search',
                                      style: TextStyle(color: Colors.black87),
                                    )),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // statistics
                        showRecord
                            ? FutureBuilder(
                                future: getFutureMethod,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (data.length > 0) {
                                    return GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0, horizontal: 10),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(2, 2),
                                                        blurRadius: 12,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.10),
                                                      )
                                                    ]),
                                                child: InkWell(
                                                  onLongPress: () {
                                                    if (data[index]
                                                            ['proj_status'] ==
                                                        'completed') {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return ChangeDev(
                                                              projectId:
                                                                  data[index]
                                                                      ['id'],
                                                            );
                                                          });
                                                    }
                                                  },
                                                  onTap: () {
                                                    setState(() {
                                                      showRemarksLoading = true;
                                                      getFutureMethodforModal =
                                                          Stream.fromFuture(
                                                              getRemarks(
                                                                  data[index]
                                                                      ['id']));
                                                      testVariable =
                                                          data[index]['id'];
                                                    });

                                                    showRemarks = false;
                                                    getRemarks(
                                                        data[index]['id']);
                                                    showModalBottomSheet(
                                                        useSafeArea: true,
                                                        isScrollControlled:
                                                            true,
                                                        isDismissible: true,
                                                        enableDrag: true,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          15),
                                                                  SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.8,
                                                                          child:
                                                                              Text(
                                                                            'Title: ${data[index]['proj_name']}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'fontOne',
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.cancel),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Divider(),
                                                                  // cost
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      'Total: ${data[index]['proj_gross']}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'fontOne',
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      'Paid: ${data[index]['proj_paid']}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'fontOne',
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      'Pending: ${data[index]['proj_balance']}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'fontOne',
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                  // remarks list
                                                                  const Divider(),
                                                                  const Row(
                                                                    children: [
                                                                      Text(
                                                                        'Developer Remarks',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(
                                                                        'Project Manager Remarks',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  StreamBuilder(
                                                                    stream:
                                                                        getFutureMethodforModal,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (showRemarks) {
                                                                        return ListView.builder(
                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: remarksData.length,
                                                                            itemBuilder: (context, remarksIndex) {
                                                                              return Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: messages(
                                                                                  remarksData[remarksIndex]['id'],
                                                                                  remarksData[remarksIndex]['remarks_by'],
                                                                                  remarksData[remarksIndex]['remarks'],
                                                                                  remarksData[remarksIndex]['proj_links'],
                                                                                  remarksData[remarksIndex]['remarks_date'],
                                                                                ),
                                                                              );
                                                                            });
                                                                      } else {
                                                                        return showRemarksLoading
                                                                            ? SizedBox(
                                                                                height: MediaQuery.of(context).size.height * 0.1,
                                                                                child: LottieBuilder.asset('assets/animations/loading.json'))
                                                                            : const Text(
                                                                                'No Remarks found',
                                                                                style: TextStyle(
                                                                                  fontFamily: 'fontTwo',
                                                                                ),
                                                                              );
                                                                      }
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Card(
                                                    elevation: 0,
                                                    color: MyColor.projectCard,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 5, 5),
                                                      child: Stack(
                                                        children: [
                                                          data[index]['proj_status'] !=
                                                                  'completed'
                                                              ? Positioned(
                                                                  top: 0,
                                                                  right: -6,
                                                                  child: PopupMenuButton(
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .info_outlined,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      onSelected: (value) {
                                                                        if (value ==
                                                                            'complete') {
                                                                          projectComplete(data[index]
                                                                              [
                                                                              'id']);
                                                                        } else if (value ==
                                                                            'discard') {
                                                                          projectDiscard(data[index]
                                                                              [
                                                                              'id']);
                                                                        } else if (value ==
                                                                            'remarks') {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => MyPmRemarksForm(
                                                                                        projectID: data[index]['id'],
                                                                                      )));
                                                                        } else if (value ==
                                                                            'change') {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return ChangeDev(
                                                                                  projectId: data[index]['id'],
                                                                                );
                                                                              });
                                                                        } else if (value ==
                                                                            'questionnaire') {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return QuestionPage(
                                                                                  id: data[index]['id'],
                                                                                );
                                                                              });
                                                                        }
                                                                      },
                                                                      itemBuilder: (context) => [
                                                                            const PopupMenuItem(
                                                                                value: 'remarks',
                                                                                child: Text(
                                                                                  'Remarks',
                                                                                  style: TextStyle(fontFamily: 'fontThree', fontSize: 14),
                                                                                )),
                                                                            const PopupMenuItem(
                                                                                value: 'complete',
                                                                                child: Text(
                                                                                  'Complete',
                                                                                  style: TextStyle(fontFamily: 'fontThree', fontSize: 14),
                                                                                )),
                                                                            const PopupMenuItem(
                                                                                value: 'discard',
                                                                                child: Text(
                                                                                  'Discard',
                                                                                  style: TextStyle(fontFamily: 'fontThree', fontSize: 14),
                                                                                )),
                                                                            const PopupMenuItem(
                                                                                value: 'change',
                                                                                child: Text(
                                                                                  'Change Developer',
                                                                                  style: TextStyle(fontFamily: 'fontThree', fontSize: 14),
                                                                                )),
                                                                            const PopupMenuItem(
                                                                                value: 'questionnaire',
                                                                                child: Text(
                                                                                  'Questionnaire',
                                                                                  style: TextStyle(fontFamily: 'fontThree', fontSize: 14),
                                                                                )),
                                                                          ]),
                                                                )
                                                              : const Positioned(
                                                                  top: 15,
                                                                  right: 6,
                                                                  child: Icon(
                                                                    Icons
                                                                        .verified,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: 18,
                                                                  ),
                                                                ),

                                                          Positioned(
                                                            top: 15,
                                                            left: 0,
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      data[index]
                                                                          [
                                                                          'proj_name'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'fontTwo',
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: MyColor
                                                                            .primaryText,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // progress bar *********
                                                          Positioned(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.08,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        elevation:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10.0),
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.15,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.20,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(
                                                                                  data[index]['proj_name'],
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'fontOne',
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                // startdate
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text('Start Date: ${data[index]['proj_startdate']}',
                                                                                          style: const TextStyle(fontFamily: 'fontTwo', fontSize: 16, fontWeight: FontWeight.bold
                                                                                              // color: Colors.green,
                                                                                              )),
                                                                                    ),
                                                                                    // end date
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text('End Date: ${data[index]['proj_enddate']}',
                                                                                          style: const TextStyle(
                                                                                            fontFamily: 'fontTwo',
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          )),
                                                                                    ),
                                                                                    // developer name
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        'Developer: ${data[index]['dev_name']}',
                                                                                        style: const TextStyle(
                                                                                          fontFamily: 'fontTwo',
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    // client name
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        'Client: ${data[index]['cli_name']}',
                                                                                        style: const TextStyle(
                                                                                          fontFamily: 'fontTwo',
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child:
                                                                  CircularStepProgressIndicator(
                                                                totalSteps: 100,
                                                                currentStep: int.parse(data[index]
                                                                            [
                                                                            'proj_progress']) ==
                                                                        0
                                                                    ? 0
                                                                    : int.parse(
                                                                        data[index]
                                                                            [
                                                                            'proj_progress']),
                                                                selectedColor: int.parse(data[index]
                                                                            [
                                                                            'proj_progress']) <
                                                                        25
                                                                    ? Colors.red
                                                                    : int.parse(data[index]['proj_progress']) <
                                                                            50
                                                                        ? Colors
                                                                            .orange
                                                                        : int.parse(data[index]['proj_progress']) <
                                                                                75
                                                                            ? Colors.yellow
                                                                            : Colors.green,
                                                                unselectedColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        224,
                                                                        224,
                                                                        224),
                                                                width: 80,
                                                                height: 80,
                                                                stepSize: 10,
                                                                selectedStepSize:
                                                                    10,
                                                                roundedCap:
                                                                    (_, __) =>
                                                                        false,
                                                                child: Center(
                                                                  child: Text(
                                                                    (data[index]['proj_progress'] ==
                                                                            0)
                                                                        ? '0%'
                                                                        : '${data[index]['proj_progress']}%',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'fontTwo',
                                                                      fontSize:
                                                                          14,
                                                                      color: MyColor
                                                                          .primaryText,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // *************************
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    return const SizedBox(
                                      child: Text(
                                          'Some error has occured. Please report to Dev Immediately.'),
                                    );
                                  }
                                },
                              )
                            : Center(
                                child: LottieBuilder.asset(
                                    'assets/animations/nodata_available.json'),
                              ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: LottieBuilder.asset(
                          'assets/animations/loading.json'))),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue.shade100,
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyChatList()));
            },
            child: const Icon(
              Icons.chat_bubble,
              color: Colors.black,
            ),
          ),
          drawer: const MyDrawerInfo()),
    );
  }

  Widget messages(String id, String remarksBy, String remarks, String projLinks,
      String remarksDate) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment:
            remarksBy == 'dev' ? Alignment.centerLeft : Alignment.centerRight,
        child: remarksBy == 'dev'
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade50,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      topLeft: Radius.circular(-20.0),
                    ),
                    // border: Border.all(
                    //   color: Colors.grey,
                    //   width: 1.0,
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Align(
                          // DateFormat('d, MMM y').format(DateTime.parse('2023-02-15'));
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat('MMMM d, y')
                                .format(DateTime.parse(remarksDate)),
                            style: const TextStyle(
                              fontFamily: 'fontTwo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SelectableText(
                            remarks,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        projLinks != ''
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      Future<void> launchBrowser(
                                          Uri url) async {
                                        if (!await launchUrl(
                                          url,
                                          mode: LaunchMode.inAppWebView,
                                          webViewConfiguration:
                                              const WebViewConfiguration(
                                                  enableDomStorage: true),
                                        )) {
                                          throw Exception(
                                              'could not launch $url');
                                        }
                                      }

                                      launchBrowser(Uri.parse(projLinks));
                                      if (projLinks.contains('https://')) {
                                        launchBrowser(Uri.parse(projLinks));
                                      } else {
                                        launchBrowser(
                                            Uri.parse('https://$projLinks'));
                                      }
                                    },
                                    onDoubleTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: projLinks));
                                      // Toast.show('Text Copied');
                                    },
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            projLinks,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue.shade900,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    // border: Border.all(
                    //   color: Colors.grey,
                    //   width: 1.0,
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat('MMMM d, y')
                                .format(DateTime.parse(remarksDate)),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            remarks,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        projLinks != ''
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      Future<void> launchBrowser(
                                          Uri url) async {
                                        if (!await launchUrl(
                                          url,
                                          mode: LaunchMode.inAppWebView,
                                          webViewConfiguration:
                                              const WebViewConfiguration(
                                                  enableDomStorage: true),
                                        )) {
                                          throw Exception(
                                              'could not launch $url');
                                        }
                                      }

                                      launchBrowser(Uri.parse(projLinks));
                                      if (projLinks.contains('https://')) {
                                        launchBrowser(Uri.parse(projLinks));
                                      } else {
                                        launchBrowser(
                                            Uri.parse('https://$projLinks'));
                                      }
                                    },
                                    onDoubleTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: projLinks));
                                    },
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            projLinks,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                      'Delete remark?',
                                      style: TextStyle(
                                          fontFamily: 'fontOne',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: const Text(
                                      'This action cannot be undone',
                                      style: TextStyle(
                                        fontFamily: 'fontTwo',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          deleteRemarks(id);

                                          setState(() {
                                            getFutureMethodforModal =
                                                Stream.fromFuture(
                                                    getRemarks(testVariable));
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
