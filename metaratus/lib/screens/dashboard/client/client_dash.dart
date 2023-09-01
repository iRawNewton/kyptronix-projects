import 'dart:convert';
import 'package:client_onboarding_app/chat/clientchatfolder/chatlist.dart';
import 'package:client_onboarding_app/screens/dashboard/client/colorwidget.dart';
import 'package:client_onboarding_app/screens/widgets/clientwidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/string_file.dart';
import '../../../notification/notificationui/notificationui.dart';
import '../../remarks/proj_remarks.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyClientDashboard extends StatefulWidget {
  const MyClientDashboard({super.key});

  @override
  State<MyClientDashboard> createState() => _MyClientDashboardState();
}

class _MyClientDashboardState extends State<MyClientDashboard> {
  // List projectDetails = [];
  final user = FirebaseAuth.instance.currentUser;
  var clientName = '';
  var projName = '';
  String cliID = '';
  int progress = 0;
  String? iprogress;
  dynamic data;
  dynamic remarksData;
  dynamic complete;
  dynamic ongoing;
  dynamic pending;
  dynamic cancelled = 0;
  late Map<String, dynamic> userMap;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String manager = '';
  bool isNotLoading = false;
  String currentUsername = '';
  String managerName = '';
  String managerUsername = '';
  DateTime date = DateTime.now();
  late Future getFutureMethod;
  bool showRecord = false;

  String projectId = '';
  late Future getRemarksMethod;
  bool showRemarks = false;
  String notiNumber = '';

  getProjID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    setState(() {
      cliID = clientID.toString();
    });

    String? name = prefs.getString('cliname');

    // notification**********************************
    var notiCounter = await http.post(
        Uri.parse('$tempUrl/notification/notificationCounterCli.php'),
        body: {
          'proj_Cli_id': cliID,
        });

    if (notiCounter.statusCode == 200) {
      dynamic jsonData1 = jsonDecode(notiCounter.body);

      setState(() {
        notiNumber = jsonData1.length.toString();
      });
    } else {}
    // notification

    var response = await http.post(
        Uri.parse('$tempUrl/client/dashboard/clientDashboard.php'),
        body: {
          'proj_cli_id': cliID,
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      setState(() {
        isNotLoading = true;
        showRecord = true;
        currentUsername = data[0]['cli_userid'];
        clientName = name.toString();
      });
    } else {}
  }

  getRemarks(projectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();
    // for remarks
    var iresponse = await http
        .post(Uri.parse('$tempUrl/client/dashboard/remarksList.php'), body: {
      'proj_cli_id': cliID,
      'proj_id': projectId,
    });
    if (iresponse.statusCode == 200) {
      dynamic x = jsonDecode(iresponse.body);

      if (x == 'Found Nothing') {
        setState(() {
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

  getOnComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();
    String? name = prefs.getString('cliname');

    var response = await http
        .post(Uri.parse('$tempUrl/client/dashboard/getOnComplete.php'), body: {
      'proj_cli_id': cliID,
    });
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          isNotLoading = true;
          showRecord = true;
          currentUsername = data[0]['cli_userid'];
          clientName = name.toString();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();
    String? name = prefs.getString('cliname');

    var response = await http
        .post(Uri.parse('$tempUrl/client/dashboard/getOnGoing.php'), body: {
      'proj_cli_id': cliID,
    });
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          isNotLoading = true;
          showRecord = true;
          currentUsername = data[0]['cli_userid'];
          clientName = name.toString();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();
    String? name = prefs.getString('cliname');

    var response = await http
        .post(Uri.parse('$tempUrl/client/dashboard/getOnPending.php'), body: {
      'proj_cli_id': cliID,
    });

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          isNotLoading = true;
          showRecord = true;
          currentUsername = data[0]['cli_userid'];
          clientName = name.toString();
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

// pass project manager's email ID
  void onSearch() async {
    // shared prefs se get current client id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String clientidTofindManager = clientID.toString();
    // pass it to api and find manager name aligned with this client
    var response = await http.post(Uri.parse('$tempUrl/getManager.php'), body: {
      'proj_manager': clientidTofindManager,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        manager = data[0]['cli_email'];
        isNotLoading = true;
      });
    }
    // onCustomSearch(manager);
  }

  // onCustomSearch(senderEmail) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   firestore
  //       .collection('users')
  //       .where('email', isEqualTo: manager)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       userMap = value.docs[0].data();
  //     });
  //   });
  //   // setState(() {
  //   //   roomIDGroup = chatRoomId(auth.currentUser!.displayName!, userMap['name']);
  //   //   isLoading = false;
  //   // });
  // }

// statistics
  Future onComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();

    var response =
        await http.post(Uri.parse('$tempUrl/project/onComplete.php'), body: {
      'proj_cli_id': cliID,
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
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();
    var response =
        await http.post(Uri.parse('$tempUrl/project/onGoing.php'), body: {
      'proj_cli_id': cliID,
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
    String? clientID = prefs.getString('cliId');
    String cliID = clientID.toString();
    var response =
        await http.post(Uri.parse('$tempUrl/project/onPending.php'), body: {
      'proj_cli_id': cliID,
    });
    if (response.statusCode == 200) {
      var ionpending = jsonDecode(response.body);
      setState(() {
        pending = ionpending[0]['pending'];
      });
    }
  }

  Future onCancelled() async {
    cancelled = 0;
  }

  Future<void> launchInappWebview(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    getProjID();
    onSearch();
    onComplete();
    onGoing();
    onPending();

    getFutureMethod = getProjID();
    // getRemarks(projectId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style:
                TextStyle(fontFamily: 'fontOne', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade100,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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
                                  userid: cliID,
                                  user: 'Cli',
                                )));
                  },
                  icon: const Icon(Icons.notifications),
                  color: Colors.black87,
                ),
              ],
            ),
          ],
        ),
        body: isNotLoading
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.lightBlue.shade100,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topLeft,
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03),
                              Text(
                                'Hi ',
                                style: TextStyle(
                                    fontFamily: 'fontOne',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.primary),
                              ),
                              Text(
                                '$clientName,',
                                style: TextStyle(
                                    fontFamily: 'fontOne',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),

                          const SizedBox(height: 30),
                          // box border welcome lets schedule
                          GestureDetector(
                            onTap: () async {
                              // void launchEmail() async {
                              //   final Uri email = Uri(
                              //     scheme: 'mailto',
                              //     path: 'kyptronix@gmail.com',
                              //     queryParameters: {
                              //       'Subject': Uri.encodeFull(''),
                              //     },
                              //   );
                              //   launchUrl(email,
                              //       mode: LaunchMode.externalApplication);
                              // }

                              // launchEmail();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 1, 55, 99),
                                    border: Border.all(
                                        width: 2, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome to Metaratus',
                                        style: TextStyle(
                                            fontFamily: 'fontTwo',
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      // Text(
                                      //   // your project information
                                      //   'Track your Project',
                                      //   textAlign: TextAlign.justify,
                                      //   style: TextStyle(
                                      //     fontFamily: 'fontTwo',
                                      //     fontSize: 24,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                              Icons
                                                  .insert_chart_outlined_rounded,
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isNotLoading = false;
                                          getFutureMethod = getOnCancelled();
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.cancel_presentation_rounded,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                    fontFamily: 'fontOne',
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Cancelled',
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
                                )
                              ],
                            ),
                          ),
                          // const SizedBox(height: 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      getFutureMethod = getProjID();
                                    });
                                  },
                                  child: const Text(
                                    'All Projects',
                                    style: TextStyle(
                                        fontFamily: 'fontTwo',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    showRecord
                        ? FutureBuilder(
                            future: getFutureMethod,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (data.length > 0) {
                                return GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height *
                                              0.55),
                                    ),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Container(
                                            decoration:
                                                const BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.10),
                                              )
                                            ]),
                                            child: InkWell(
                                              onTap: () {
                                                showRemarks = false;
                                                getRemarks(data[index]['id']);

                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) {
                                                //       return Dialog(
                                                //         shape: RoundedRectangleBorder(
                                                //             borderRadius:
                                                //                 BorderRadius
                                                //                     .circular(
                                                //                         10)),
                                                //         elevation: 0,
                                                //         child: Container(
                                                //           padding:
                                                //               const EdgeInsets
                                                //                       .symmetric(
                                                //                   horizontal:
                                                //                       10.0),
                                                //           height: MediaQuery.of(
                                                //                       context)
                                                //                   .size
                                                //                   .height *
                                                //               0.35,
                                                //           width: MediaQuery.of(
                                                //                       context)
                                                //                   .size
                                                //                   .width *
                                                //               0.9,
                                                //           decoration:
                                                //               BoxDecoration(
                                                //             borderRadius:
                                                //                 BorderRadius
                                                //                     .circular(
                                                //                         10),
                                                //             color: Colors
                                                //                 .blue.shade50,
                                                //           ),
                                                //           child:
                                                //               SingleChildScrollView(
                                                //             child: Column(
                                                //               mainAxisAlignment:
                                                //                   MainAxisAlignment
                                                //                       .spaceEvenly,
                                                //               children: [
                                                //                 const SizedBox(
                                                //                     height: 20),
                                                //                 Text(
                                                //                   data[index][
                                                //                       'proj_name'],
                                                //                   style:
                                                //                       const TextStyle(
                                                //                     fontFamily:
                                                //                         'fontOne',
                                                //                     fontSize:
                                                //                         18,
                                                //                     fontWeight:
                                                //                         FontWeight
                                                //                             .bold,
                                                //                   ),
                                                //                 ),
                                                //                 // amount
                                                //                 Row(
                                                //                   children: const [
                                                //                     Text(
                                                //                       'Gross Amount: ',
                                                //                       style: TextStyle(
                                                //                           fontFamily:
                                                //                               'fontOne',
                                                //                           fontSize:
                                                //                               16),
                                                //                     ),
                                                //                     Text(
                                                //                       'Amount Paid: ',
                                                //                       style: TextStyle(
                                                //                           fontFamily:
                                                //                               'fontOne',
                                                //                           fontSize:
                                                //                               16),
                                                //                     ),
                                                //                   ],
                                                //                 ),
                                                //                 Column(
                                                //                   mainAxisAlignment:
                                                //                       MainAxisAlignment
                                                //                           .spaceEvenly,
                                                //                   children: [
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             10),
                                                //                     Row(
                                                //                       children: [
                                                //                         const Text(
                                                //                           'Remarks: ',
                                                //                           style: TextStyle(
                                                //                               fontFamily: 'fontTwo',
                                                //                               fontSize: 14),
                                                //                         ),
                                                //                         Text(
                                                //                           data[index]
                                                //                               [
                                                //                               'proj_remarks'],
                                                //                           style: const TextStyle(
                                                //                               fontFamily: 'fontTwo',
                                                //                               fontSize: 14),
                                                //                         )
                                                //                       ],
                                                //                     ),
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             20),
                                                //                     Row(
                                                //                       children: [
                                                //                         const Text(
                                                //                           'Link: ',
                                                //                           style: TextStyle(
                                                //                               fontFamily: 'fontTwo',
                                                //                               fontSize: 14),
                                                //                         ),
                                                //                         TextButton(
                                                //                             onPressed:
                                                //                                 () {
                                                //                               Uri uri = Uri.parse('https://${data[index]['proj_link'].toString()}');
                                                //                               launchInappWebview(uri);
                                                //                               Navigator.pop(context);
                                                //                             },
                                                //                             child:
                                                //                                 Text(
                                                //                               data[index]['proj_link'],
                                                //                               style: const TextStyle(fontFamily: 'fontTwo', fontSize: 14),
                                                //                             )),
                                                //                       ],
                                                //                     ),
                                                //                     const SizedBox(
                                                //                         height:
                                                //                             20),
                                                //                   ],
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //           ),
                                                //         ),
                                                //       );
                                                //     });
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    isDismissible: true,
                                                    enableDrag: true,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 15),
                                                              Text(
                                                                'Title: ${data[index]['proj_name']}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'fontOne',
                                                                    fontSize:
                                                                        24),
                                                              ),
                                                              const Divider(),
                                                              // cost
                                                              Align(
                                                                alignment: Alignment
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
                                                                alignment: Alignment
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
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  'Balance: ${data[index]['proj_balance']}',
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

                                                              FutureBuilder(
                                                                future: getRemarks(
                                                                    data[index]
                                                                        ['id']),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (showRemarks) {
                                                                    return ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: remarksData.length,
                                                                        itemBuilder: (context, remarksIndex) {
                                                                          return Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                messages(
                                                                              remarksData[remarksIndex]['remarks_by'],
                                                                              remarksData[remarksIndex]['remarks'],
                                                                              remarksData[remarksIndex]['proj_links'],
                                                                              remarksData[remarksIndex]['remarks_date'],
                                                                            ),
                                                                          );
                                                                        });
                                                                  } else {
                                                                    return const Text(
                                                                      'No Remarks Found',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'fontTwo',
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
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Date: ${DateFormat('dd MMMM, yyyy').format(
                                                                    DateTime
                                                                        .parse(
                                                                      data[index]
                                                                          [
                                                                          'proj_startdate'],
                                                                    ),
                                                                  )}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'fontTwo',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: MyColor
                                                                        .primaryText,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                data[index][
                                                                    'proj_name'],
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'fontTwo',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyColor
                                                                      .primaryText,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.01),

                                                            // progress bar
                                                            CircularStepProgressIndicator(
                                                              totalSteps: 100,
                                                              currentStep: (int.parse(
                                                                          data[index]
                                                                              [
                                                                              'proj_progress']) ==
                                                                      0)
                                                                  ? 0
                                                                  : int.parse(data[
                                                                          index]
                                                                      [
                                                                      'proj_progress']),
                                                              selectedColor: int.parse(data[
                                                                              index]
                                                                          [
                                                                          'proj_progress']) <
                                                                      25
                                                                  ? Colors.red
                                                                  : int.parse(data[index]
                                                                              [
                                                                              'proj_progress']) <
                                                                          50
                                                                      ? Colors
                                                                          .orange
                                                                      : int.parse(data[index]['proj_progress']) <
                                                                              75
                                                                          ? Colors
                                                                              .yellow
                                                                          : Colors
                                                                              .green,
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
                                                                  (int.parse(data[index]
                                                                              [
                                                                              'proj_progress']) ==
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
                                                            TextButton.icon(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const MyClientReview()));
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .reviews_rounded,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          1,
                                                                          55,
                                                                          99),
                                                                ),
                                                                label:
                                                                    const Text(
                                                                  'Share Review',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'fontTwo',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            1,
                                                                            55,
                                                                            99),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
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
                            child: LottieBuilder.network(
                                'https://assets4.lottiefiles.com/packages/lf20_rjn0esjh.json'),
                          ),
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child:
                        LottieBuilder.asset('assets/animations/loading.json'))),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue.shade50,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? clientID = prefs.getString('cliId');
              String cliID = clientID.toString();

              hello() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyClientChatList(clientIdForChat: cliID),
                  ),
                );
              }

              hello();
            },
            child: Icon(
              Icons.chat_bubble_outline,
              color: Colors.blue.shade400,
            )),
        drawer: const MyClientDrawyer(),
      ),
    );
  }

  // widget
  Widget messages(
      String remarksBy, String remarks, String projLinks, String remarksDate) {
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
                      ],
                    ),
                  ),
                ),
              ));
  }
}
