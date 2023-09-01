import 'dart:async';
import 'dart:convert';
import 'package:client_onboarding_app/notification/notificationui/notificationui.dart';
import 'package:client_onboarding_app/screens/dashboard/admin/detailsdialog.dart';
import 'package:client_onboarding_app/screens/dashboard/client/colorwidget.dart';
import 'package:client_onboarding_app/screens/widgets/adminwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jumping_dot/jumping_dot.dart';
import 'package:lottie/lottie.dart';

import '../../../chat/groupchat/groupchatroom.dart';
import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyAdminDash extends StatefulWidget {
  const MyAdminDash({super.key});

  @override
  State<MyAdminDash> createState() => _MyAdminDashState();
}

class _MyAdminDashState extends State<MyAdminDash> {
  dynamic data;
  bool recordPresent = false;
  bool dataAvailable = false;
  int projectComplete = 0;
  int projectOngoing = 0;
  int projectPending = 0;
  bool chatLoader = false;
  String notiNumber = '';

  Future getDevList() async {
    var response =
        await http.post(Uri.parse('$tempUrl/dev/getEntireDevList.php'));
    if (response.statusCode == 200) {
      dataAvailable = true;
      data = jsonDecode(response.body);
      if (data.length == 0) {
        setState(() {
          recordPresent = false;
        });
      } else {
        setState(() {
          recordPresent = true;
        });
      }
    }
  }

  getOnComplete() async {
    var response = await http
        .post(Uri.parse('$tempUrl/admin/stats/OnCompleteAdmin.php'), body: {});
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          projectComplete = data.length;
        });
      } else {
        setState(() {
          // isNotLoading = true;
          // showRecord = false;
        });
      }
    }
  }

  getOnGoing() async {
    var response = await http
        .post(Uri.parse('$tempUrl/admin/stats/OnGoingAdmin.php'), body: {});
    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          projectOngoing = data.length;
        });
      } else {
        setState(() {
          // isNotLoading = true;
          // showRecord = false;
        });
      }
    }
  }

  getOnPending() async {
    var response = await http
        .post(Uri.parse('$tempUrl/admin/stats/OnPendingAdmin.php'), body: {});

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        data = jsonDecode(response.body);
        setState(() {
          projectPending = data.length;
        });
      } else {
        setState(() {});
      }
    }
  }

  Future getNotificationID() async {
    var notiCounter = await http.post(
      Uri.parse('$tempUrl/notification/notificationCounterAdmin.php'),
    );

    if (mounted && notiCounter.statusCode == 200) {
      var jsonData1 = jsonDecode(notiCounter.body);

      setState(() {
        notiNumber = jsonData1[0]['count'].toString();
      });
    } else {}
  }

  @override
  void initState() {
    getDevList();
    getOnComplete();
    getOnGoing();
    getOnPending();
    getNotificationID();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        getNotificationID();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade200,
          centerTitle: true,
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              fontFamily: 'fontOne',
              fontWeight: FontWeight.bold,
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
                            builder: (context) => const MyNotificationUi(
                                  user: 'Admin',
                                  userid: '0',
                                )));
                  },
                  icon: const Icon(Icons.notifications),
                  color: Colors.black87,
                ),
              ],
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: dataAvailable
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      // welcome text
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hi Super Admin',
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 55, 99),
                            fontFamily: 'fontOne',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // statistics

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 30.0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Overall Statistics',
                                style: TextStyle(
                                  fontFamily: 'fontTwo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // setState(() {
                                    //   isNotLoading = false;
                                    //   getFutureMethod = getOnComplete();
                                    // });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: MyColor.totalCard,
                                      border: Border.all(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                              '$projectComplete',
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
                                    // setState(() {
                                    //   isNotLoading = false;
                                    //   getFutureMethod = getOnGoing();
                                    // });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: MyColor.ongoingCard,
                                      border: Border.all(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                              '$projectOngoing',
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
                                    // setState(() {
                                    //   isNotLoading = false;
                                    //   getFutureMethod = getOnPending();
                                    // });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: MyColor.notstartedCard,
                                      border: Border.all(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                              '$projectPending',
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
                                    // setState(() {
                                    //   isNotLoading = false;
                                    //   getFutureMethod = getOnCancelled();
                                    // });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: MyColor.cancelCard,
                                      border: Border.all(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15.0),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Development Team',
                          style: TextStyle(
                            fontFamily: 'fontThree',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      recordPresent
                          ? FutureBuilder(
                              future: getDevList(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (data.length > 0) {
                                  return GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 2 / 2,
                                        crossAxisCount: 2,
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
                                                onTap: () {},
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        barrierColor:
                                                            Colors.black54,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AdminShowDialog(
                                                            devId: data[index]
                                                                ['id'],
                                                            phone: data[index]
                                                                ['cli_phone'],
                                                            whatsapp: data[
                                                                    index][
                                                                'cli_whatsapp'],
                                                            email: data[index]
                                                                ['cli_email'],
                                                          );

                                                          // return AlertDialog(
                                                          //   elevation: 5,
                                                          //   actions: [
                                                          //     const SizedBox(
                                                          //         height: 30),
                                                          //     Row(
                                                          //       mainAxisAlignment:
                                                          //           MainAxisAlignment
                                                          //               .spaceBetween,
                                                          //       children: [
                                                          //         SizedBox(
                                                          //           width: MediaQuery.of(context)
                                                          //                   .size
                                                          //                   .width *
                                                          //               0.13,
                                                          //           child:
                                                          //               IconButton(
                                                          //             onPressed:
                                                          //                 () {
                                                          //               void launchCall(
                                                          //                   number) async {
                                                          //                 final Uri
                                                          //                     phoneNumber =
                                                          //                     Uri.parse('tel:$number');
                                                          //                 launchUrl(
                                                          //                     phoneNumber);
                                                          //               }

                                                          //               launchCall(data[index]
                                                          //                   [
                                                          //                   'cli_phone']);
                                                          //             },
                                                          //             icon: Image
                                                          //                 .asset(
                                                          //               'assets/images/call.png',
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //         SizedBox(
                                                          //           width: MediaQuery.of(context)
                                                          //                   .size
                                                          //                   .width *
                                                          //               0.15,
                                                          //           child:
                                                          //               IconButton(
                                                          //             onPressed:
                                                          //                 () {
                                                          //               void launchWhatsApp(
                                                          //                   number) async {
                                                          //                 final Uri
                                                          //                     whatsApp =
                                                          //                     Uri.parse('https://wa.me/$number?');
                                                          //                 launchUrl(
                                                          //                     whatsApp,
                                                          //                     mode: LaunchMode.externalApplication);
                                                          //               }

                                                          //               launchWhatsApp(data[index]
                                                          //                   [
                                                          //                   'cli_whatsapp']);
                                                          //             },
                                                          //             icon: Image
                                                          //                 .asset(
                                                          //               'assets/images/whatsapp.png',
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //         SizedBox(
                                                          //           width: MediaQuery.of(context)
                                                          //                   .size
                                                          //                   .width *
                                                          //               0.13,
                                                          //           child:
                                                          //               IconButton(
                                                          //             onPressed:
                                                          //                 () {
                                                          //               void launchEmail(
                                                          //                   number) async {
                                                          //                 final Uri
                                                          //                     email =
                                                          //                     Uri(
                                                          //                   scheme:
                                                          //                       'mailto',
                                                          //                   path:
                                                          //                       data[index]['cli_email'],
                                                          //                   queryParameters: {},
                                                          //                 );
                                                          //                 launchUrl(
                                                          //                     email,
                                                          //                     mode: LaunchMode.externalApplication);
                                                          //               }

                                                          //               launchEmail(data[index]
                                                          //                   [
                                                          //                   'cli_email']);
                                                          //             },
                                                          //             icon: Image
                                                          //                 .asset(
                                                          //               'assets/images/gmail.png',
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       ],
                                                          //     ),
                                                          //   ],
                                                          // );
                                                        });
                                                  },
                                                  child: Card(
                                                    elevation: 0,
                                                    color: MyColor.projectCard,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 0.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const SizedBox(
                                                              height: 20),
                                                          const Icon(
                                                              Icons.person,
                                                              size: 50),
                                                          // const Spacer(),
                                                          const Divider(),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              data[index]
                                                                  ['cli_name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'fontTwo',
                                                                fontSize: 18,
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              data[index][
                                                                  'cli_designation'],
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'fontTwo',
                                                                fontSize: 18,
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
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                    child: Text('No data available.'),
                                  );
                                }
                              },
                            )
                          : Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  children: [
                                    LottieBuilder.asset(
                                        'assets/animations/not_found.json'),
                                    const Text(
                                      'No Records Found...',
                                      style: TextStyle(
                                        fontFamily: 'fontTwo',
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child:
                        LottieBuilder.asset('assets/animations/loading.json'),
                  ),
                ),
        ),
        drawer: const MyAdminDrawyer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade100,
          onPressed: () {
            setState(() {
              chatLoader = true;
            });
            onCustomSearch(senderEmail, senderName, context) async {
              dynamic userMap;
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              await firestore
                  .collection('users')
                  .where('email', isEqualTo: senderEmail)
                  .get()
                  .then((value) {
                setState(() {
                  userMap = value.docs[0].data();
                });
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GroupChatRoom(
                      senderEmail: senderEmail,
                      chatRoomId: 'DevelopmentTeam',
                      userMap: userMap,
                      currentUsername: senderName,
                      senderName: senderName,
                      senderUsername: 'cliUsername'),
                ),
              );
              // goToCustomChatScreen(senderEmail, senderName, context);
            }

            onCustomSearch('kyptronix@gmail.com', 'Admin', context);
            Future.delayed(const Duration(seconds: 5), () {
              setState(() {
                chatLoader = false;
              });
            });
          },
          child: chatLoader
              ? JumpingDots(
                  color: Colors.black,
                  radius: 5,
                  numberOfDots: 3,
                  animationDuration: const Duration(milliseconds: 400),
                )
              : const Icon(Icons.chat),
        ),
      ),
    );
  }
}
