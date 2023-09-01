import 'dart:async';

import 'package:client_onboarding_app/notification/notificationui/timefunction.dart';
import 'package:client_onboarding_app/screens/daily_task/developer/daily_task.dart';
import 'package:client_onboarding_app/screens/dashboard/client/client_dash.dart';
import 'package:client_onboarding_app/screens/newproject/newproject.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/string_file.dart';
import '../../screens/assignproject/developer/assignproject.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyNotificationUi extends StatefulWidget {
  const MyNotificationUi({super.key, required this.userid, required this.user});

  final String userid;
  final String user;

  @override
  State<MyNotificationUi> createState() => _MyNotificationUiState();
}

class _MyNotificationUiState extends State<MyNotificationUi> {
  dynamic data;
  bool showLoading = false;
  Future<dynamic> getFutureMethod = Future.value();
  Timer? timer;

  Widget toggleLoading = SizedBox(
    height: 100,
    child: LottieBuilder.asset('assets/animations/loading.json'),
  );

  Future getDevNotification(devid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    String devID = developerID.toString();
    var response = await http.post(
        Uri.parse('$tempUrl/notification/NotificationTab/notificationPage.php'),
        body: {
          'devid': devID,
        });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length > 0) {
        setState(() {
          showLoading = true;
        });
      } else {
        setState(() {
          toggleLoading =
              LottieBuilder.asset('assets/animations/nodata_available.json');
        });
      }
    }
  }

  Future getPmNotification(devid) async {
    // Perform the continuous function here

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    String pmid = pmID.toString();

    var response = await http.post(
        Uri.parse('$tempUrl/notification/NotificationTab/notificationPm.php'),
        body: {
          'pmid': pmid,
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (mounted && data.length > 0) {
        setState(() {
          showLoading = true;
        });
      } else {
        setState(() {
          toggleLoading = SizedBox(
              child: LottieBuilder.asset(
                  'assets/animations/nodata_available.json'));
        });
      }
    }
  }

  Future getCliNotification(devid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientID = prefs.getString('cliId');
    String clientid = clientID.toString();
    // print(clientid);
    var response = await http.post(
        Uri.parse('$tempUrl/notification/NotificationTab/notificationCli.php'),
        body: {
          'CliId': clientid,
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length > 0) {
        setState(() {
          showLoading = true;
        });
      } else {
        setState(() {
          toggleLoading = SizedBox(
              child: LottieBuilder.asset(
                  'assets/animations/nodata_available.json'));
        });
      }
    }
  }

  Future<void> getAdminNotification() async {
    var response = await http.post(
      Uri.parse('$tempUrl/notification/NotificationTab/notificationAdmin.php'),
    );

    if (mounted && response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length > 0) {
        setState(() {
          showLoading = true;
        });
      } else {
        setState(() {
          toggleLoading = SizedBox(
            child:
                LottieBuilder.asset('assets/animations/nodata_available.json'),
          );
        });
      }
    }
  }

  Future readNotificationDev(id, status) async {
    var response = await http.post(
        Uri.parse('$tempUrl/notification/NotificationTab/seenNotification.php'),
        body: {
          'id': id.toString(),
          'status': status,
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      // if (data.length > 0) {
      //   setState(() {
      //     showLoading = true;
      //   });
      // } else {
      //   setState(() {
      //     toggleLoading = SizedBox(
      //         height: 100,
      //         child: LottieBuilder.asset(
      //             'assets/animations/nodata_available.json'));
      //   });
      // }
    }
  }

  Future readNotificationPm(id, status) async {
    var response = await http.post(
        Uri.parse(
            '$tempUrl/notification/NotificationTab/seenNotificationPm.php'),
        body: {
          'id': id.toString(),
          'status': status,
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
  }

  Future readNotificationCli(id, status) async {
    var response = await http.post(
        Uri.parse(
            '$tempUrl/notification/NotificationTab/seenNotificationCli.php'),
        body: {
          'id': id.toString(),
          'status': status,
        });
    // print(response.body);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
  }

  Future readNotificationAdmin(id, status) async {
    var response = await http.post(
        Uri.parse(
            '$tempUrl/notification/NotificationTab/seenNotificationAdmin.php'),
        body: {
          'id': id.toString(),
          'status': status,
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
  }

  startUpdatingDevData() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getFutureMethod = getDevNotification(widget.userid);
    });
  }

  startUpdatingPmData() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getFutureMethod = getPmNotification(widget.userid);
    });
  }

  startUpdatingCliData() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getFutureMethod = getCliNotification(widget.userid);
    });
  }

  startUpdatingAdminData() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getFutureMethod = getAdminNotification();
    });
  }

  @override
  void initState() {
    setState(() {
      showLoading = false;
    });
    if (widget.user == 'Dev') {
      setState(() {
        getFutureMethod = getDevNotification(widget.userid);
      });
      startUpdatingDevData();
    } else if (widget.user == 'Pm') {
      setState(() {
        getFutureMethod = getPmNotification(widget.userid);
      });
      startUpdatingPmData();
    } else if (widget.user == 'Cli') {
      setState(() {
        getFutureMethod = getCliNotification(widget.userid);
      });
      startUpdatingCliData();
    } else if (widget.user == 'Admin') {
      setState(() {
        getFutureMethod = getAdminNotification();
      });
      startUpdatingAdminData();
    }

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: showLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: FutureBuilder(
                  future: getFutureMethod,
                  builder: (context, snapshot) {
                    if (data.length > 0) {
                      return RefreshIndicator(
                        color: Colors.indigo,
                        onRefresh: _refresh,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.user == 'Dev') {
                                          readNotificationDev(
                                              data[index]['id'], '1');

                                          data[index]['n_type'] == 'Remarks'
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyDevDailyTask()))
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyDevProjectDetails()));
                                        } else if (widget.user == 'Pm') {
                                          readNotificationPm(
                                              data[index]['id'], '1');
                                          data[index]['n_type'] ==
                                                  'Project Request'
                                              ? Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewProjectRequest(),
                                                  ),
                                                )
                                              : Navigator.pop(context);
                                        } else if (widget.user == 'Cli') {
                                          readNotificationCli(
                                              data[index]['id'], '1');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyClientDashboard()));
                                        } else if (widget.user == 'Admin') {
                                          readNotificationAdmin(
                                              data[index]['id'], '1');
                                          // data[index]['n_type'] == 'Remarks'
                                          //     ? Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                  DailyTaskDevList()))
                                          //     : Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 const MyDevProjectDetails()));
                                        }
                                      },
                                      child: Card(
                                        color: (widget.user == 'Dev')
                                            ? (data[index]['status'] == 0)
                                                ? Colors.white
                                                : Colors.grey.shade300
                                            : (widget.user == 'Pm')
                                                ? (data[index]['statusPm'] == 0)
                                                    ? Colors.white
                                                    : Colors.grey.shade300
                                                : (widget.user == 'Cli')
                                                    ? (data[index]
                                                                ['statusCli'] ==
                                                            0)
                                                        ? Colors.white
                                                        : Colors.grey.shade300
                                                    : (widget.user == 'Admin')
                                                        ? (data[index][
                                                                    'statusAdmin'] ==
                                                                0)
                                                            ? Colors.white
                                                            : Colors
                                                                .grey.shade300
                                                        : Colors.amber,
                                        elevation: 0,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.notifications,
                                                  color: Colors.black54),
                                              title:
                                                  Text(data[index]['n_type']),
                                              subtitle: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        data[index]['n_body']),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: test(
                                                        data[index]['n_time']),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                      );
                    } else {
                      return const Text('Nothing found');
                    }
                  })

              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Card(
              //         elevation: 0,
              //         child: Column(
              //           children: [
              //             ListTile(
              //               leading: const Icon(Icons.notifications,
              //                   color: Colors.black54),
              //               title: const Text('Remarks Update'),
              //               subtitle: Column(
              //                 children: const [
              //                   Align(
              //                     alignment: Alignment.centerLeft,
              //                     child: Text('Gaurab Roy added remarks in Cis'),
              //                   ),
              //                   Align(
              //                     alignment: Alignment.centerRight,
              //                     child: Text('2 hours ago'),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     )
              //   ],
              // ),

              )
          : Center(child: toggleLoading),
    );
  }

  Widget timeDisplay(body, notiTime) {
    var timeToShow = '';

    final dateTime = DateTime.parse(notiTime);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      setState(() {
        timeToShow = '${difference.inSeconds} sec ago';
      });
    } else if (difference.inMinutes < 60) {
      setState(() {
        timeToShow = '${difference.inMinutes} min ago';
      });
    } else if (difference.inHours < 24) {
      setState(() {
        timeToShow = '${difference.inHours} hr ago';
      });
    } else {
      final formatter = DateFormat('yyyy-MM-dd');
      setState(() {
        timeToShow = formatter.format(dateTime);
      });
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(body),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(timeToShow),
        )
      ],
    );
  }

  Future<void> _refresh() async {
    // await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MyNotificationUi(
                user: widget.user,
                userid: widget.userid,
              )),
    );
  }
}
