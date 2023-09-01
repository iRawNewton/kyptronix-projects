import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/string_file.dart';
import '../../dashboard/client/colorwidget.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyDevDailyTask extends StatefulWidget {
  const MyDevDailyTask({super.key});

  @override
  State<MyDevDailyTask> createState() => _MyDevDailyTaskState();
}

class _MyDevDailyTaskState extends State<MyDevDailyTask> {
  dynamic data;

  String devId = '';
  String devName = '';
  bool isNotLoading = true;
  bool showRecord = false;
  late Future getFutureMethod;
  // late Future getFutureMethodforModal;
  Stream<Object?>? getFutureMethodforModal;
  // for remarks
  dynamic remarksData;
  bool showRemarks = false;

  bool showRemarksLoading = true;
  var testVariable = '';

  bool visibility = false;
  Widget toggleAnimation = Column(
    children: [
      SizedBox(
        height: 90,
        child: Center(
          child: LottieBuilder.asset('assets/animations/loading.json'),
        ),
      ),
    ],
  );

  deleteRemarks(id) async {
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/dashboard/deleteRemarks.php'),
        body: {
          'id': id.toString(),
        });
    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> getProjectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    var developerName = prefs.getString('devname');
    setState(() {
      devId = developerID.toString();
      devName = developerName!;
    });

    var response = await http.post(
      Uri.parse('$tempUrl/devDailyTask/newGetDailytask.php'),
      body: {
        'dev_id': devId,
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
          toggleAnimation = SizedBox(
            child: Center(
              child: LottieBuilder.asset(
                  'assets/animations/nodata_available.json'),
            ),
          );
          isNotLoading = true;
          showRecord = false;
        });
      }
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

      if (x == 'Found Nothing') {
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

  @override
  void initState() {
    getProjectList();
    getFutureMethod = getProjectList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: const Text(
          'Remarks List',
          style: TextStyle(
              fontFamily: 'fontOne', fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.lightBlue.shade50,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 10),
              showRecord
                  ? FutureBuilder(
                      future: getFutureMethod,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (data.length > 0) {
                          return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
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
                                      decoration:
                                          const BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 12,
                                          color: Color.fromRGBO(0, 0, 0, 0.10),
                                        )
                                      ]),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showRemarksLoading = true;
                                            getFutureMethodforModal =
                                                Stream.fromFuture(getRemarks(
                                                    data[index]['id']));
                                            testVariable = data[index]['id'];
                                          });
                                          showRemarks = false;
                                          getRemarks(data[index]['id']);
                                          showModalBottomSheet(
                                              useSafeArea: true,
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              enableDrag: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 15),

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.7,
                                                                    child: Text(
                                                                      'Title: ${data[index]['proj_name']}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'fontOne',
                                                                          fontSize:
                                                                              24),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .cancel)),
                                                          ],
                                                        ),
                                                        const Divider(),

                                                        // remarks list
                                                        const Row(
                                                          children: [
                                                            Text(
                                                              'Developer Remarks',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              'Project Manager Remarks',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),

                                                        StreamBuilder(
                                                          stream:
                                                              getFutureMethodforModal,
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                            if (showRemarks) {
                                                              return ListView
                                                                  .builder(
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          remarksData
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              remarksIndex) {
                                                                        return Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              messages(
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
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.1,
                                                                      child: LottieBuilder
                                                                          .asset(
                                                                              'assets/animations/loading.json'))
                                                                  : const Text(
                                                                      'No Remarks found',
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
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 5, 5),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 15,
                                                  left: 0,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            data[index]
                                                                ['proj_name'],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'fontTwo',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child:
                                                      CircularStepProgressIndicator(
                                                    totalSteps: 100,
                                                    currentStep: int.parse(data[
                                                                    index][
                                                                'proj_progress']) ==
                                                            0
                                                        ? 0
                                                        : int.parse(data[index]
                                                            ['proj_progress']),
                                                    selectedColor: int.parse(data[
                                                                    index][
                                                                'proj_progress']) <
                                                            25
                                                        ? Colors.red
                                                        : int.parse(data[index][
                                                                    'proj_progress']) <
                                                                50
                                                            ? Colors.orange
                                                            : int.parse(data[
                                                                            index]
                                                                        [
                                                                        'proj_progress']) <
                                                                    75
                                                                ? Colors.yellow
                                                                : Colors.green,
                                                    unselectedColor:
                                                        const Color.fromARGB(
                                                            255, 224, 224, 224),
                                                    width: 80,
                                                    height: 80,
                                                    stepSize: 10,
                                                    selectedStepSize: 10,
                                                    roundedCap: (_, __) =>
                                                        false,
                                                    child: Center(
                                                      child: Text(
                                                        (data[index][
                                                                    'proj_progress'] ==
                                                                0)
                                                            ? '0%'
                                                            : '${data[index]['proj_progress']}%',
                                                        style: TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 14,
                                                          color: MyColor
                                                              .primaryText,
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
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.33,
                        ),
                        toggleAnimation,
                      ],
                    ),
            ]),
          )),
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
                    color: Colors.blue.shade50,
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
                        color: Colors.grey.withOpacity(0.5),
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
                              fontSize: 14,
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
                          alignment: Alignment.centerLeft,
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
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SelectableText(
                            remarks,
                            style: const TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w500,
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
