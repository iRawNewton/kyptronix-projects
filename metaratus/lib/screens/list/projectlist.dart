import 'dart:convert';
import 'package:client_onboarding_app/screens/widgets/adminwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constant/string_file.dart';
import '../dashboard/client/colorwidget.dart';
import 'package:url_launcher/url_launcher.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyProjectList extends StatefulWidget {
  const MyProjectList({super.key});

  @override
  State<MyProjectList> createState() => _MyProjectListState();
}

class _MyProjectListState extends State<MyProjectList> {
  TextEditingController searchValue = TextEditingController();
  dynamic data = [];
  Future<dynamic> getFutureMethod = Future.value();
  bool showCard = true;
  bool recordPresent = true;
  bool showRemarksLoading = true;
  dynamic remarksData;
  bool showRemarks = true;
  Stream<Object?>? getFutureMethodforModal;
  var testVariable = '';

  Future getClientList() async {
    var response =
        await http.post(Uri.parse('$tempUrl/admin/projects/projectList.php'));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length == 0) {
        setState(() {
          recordPresent = false;
        });
      } else {
        setState(() {
          showCard = true;
        });
      }
    }
  }

  searchClientList(searchText) async {
    var response = await http
        .post(Uri.parse('$tempUrl/admin/projects/searchProject.php'), body: {
      'queryvalue': searchText,
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length == 0) {
        setState(() {
          recordPresent = false;
        });
      } else {
        setState(() {
          showCard = true;
        });
      }
    } else {
      // setState(() {
      //   isVisible = true;
      // });
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

  // // delete function
  // deleteData(clientId) async {
  //   var response = await http.post(
  //       Uri.parse(
  //           '$tempUrl/client/deleteClient.php'),
  //       body: {
  //         'id': clientId.toString(),
  //       });
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       getFutureMethod = getClientList();
  //       showCard = true;
  //     });
  //   } else {}
  // }

  void launchWhatsApp(number) async {
    final Uri whatsApp = Uri.parse('https://wa.me/$number?');
    launchUrl(whatsApp, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    setState(() {
      getFutureMethod = getClientList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          centerTitle: true,
          title: const Text(
            'Project List',
            style: TextStyle(
              fontFamily: 'fontOne',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: recordPresent
            ? Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // search
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      controller: searchValue,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              getFutureMethod =
                                                  searchClientList(
                                                      searchValue.text);
                                            });
                                          },
                                          icon: const Icon(Icons.search),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // future builder
                      showCard
                          ? FutureBuilder(
                              future: getFutureMethod,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (data.length > 0) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 10),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                showRemarksLoading = true;
                                                getFutureMethodforModal =
                                                    Stream.fromFuture(
                                                        getRemarks(
                                                            data[index]['id']));
                                                testVariable =
                                                    data[index]['id'];
                                              });

                                              showRemarks = false;
                                              getRemarks(data[index]['id']);
                                              showModalBottomSheet(
                                                  useSafeArea: true,
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  enableDrag: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 15),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    child: Text(
                                                                      'Title: ${data[index]['proj_name']}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'fontOne',
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .cancel),
                                                                  )
                                                                ],
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
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (showRemarks) {
                                                                  return ListView
                                                                      .builder(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: remarksData
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, remarksIndex) {
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
                                                                          height: MediaQuery.of(context).size.height *
                                                                              0.1,
                                                                          child:
                                                                              LottieBuilder.asset('assets/animations/loading.json'))
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
                                            child: Container(
                                              // height: 150,
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 12,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.10),
                                                    )
                                                  ]),
                                              child: Card(
                                                elevation: 0,
                                                color: MyColor.projectCard,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 10, 5, 10),
                                                  child: Column(
                                                    children: [
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Name: ${data[index]['proj_name']}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'fontTwo',
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: MyColor
                                                                    .primaryText,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    launchWhatsApp(
                                                                        data[index]
                                                                            [
                                                                            'cli_phone']);
                                                                  },
                                                                  icon: Image.asset(
                                                                      'assets/images/whatsapp.png')),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Start Date: ${data[index]['proj_startdate']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: MyColor
                                                                .primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'End Date: ${data[index]['proj_enddate']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: MyColor
                                                                .primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Developer Name: ${data[index]['cli_dev']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: MyColor
                                                                .primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Client: ${data[index]['cli_cli']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: MyColor
                                                                .primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'progress: ${data[index]['proj_progress']}%',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: MyColor
                                                                .primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Total: ${data[index]['proj_gross']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'fontTwo',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyColor
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Paid: ${data[index]['proj_paid']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'fontTwo',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyColor
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Balance: ${data[index]['balance']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'fontTwo',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyColor
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      // Row(
                                                      //   children: [
                                                      //     SizedBox(
                                                      //       height: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .height *
                                                      //           0.05,
                                                      //       width: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .width *
                                                      //           0.40,
                                                      //       child: ElevatedButton
                                                      //           .icon(
                                                      //         onPressed: () {
                                                      //           Navigator.push(
                                                      //               context,
                                                      //               MaterialPageRoute(
                                                      //                   builder: (context) => MyPmCreateClient(
                                                      //                       caseOperation:
                                                      //                           'update',
                                                      //                       clientID:
                                                      //                           data[index]['id'])));
                                                      //         },
                                                      //         icon: const Icon(
                                                      //           Icons.update,
                                                      //           color:
                                                      //               Colors.white,
                                                      //         ),
                                                      //         label: const Text(
                                                      //           'UPDATE',
                                                      //           style: TextStyle(
                                                      //             fontFamily:
                                                      //                 'fontThree',
                                                      //             color: Colors
                                                      //                 .white,
                                                      //             fontSize: 14,
                                                      //           ),
                                                      //         ),
                                                      //         style: const ButtonStyle(
                                                      //             backgroundColor:
                                                      //                 MaterialStatePropertyAll(
                                                      //                     Colors
                                                      //                         .blue)),
                                                      //       ),
                                                      //     ),
                                                      //     const Spacer(),
                                                      //     SizedBox(
                                                      //       height: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .height *
                                                      //           0.05,
                                                      //       width: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .width *
                                                      //           0.40,
                                                      //       child: ElevatedButton
                                                      //           .icon(
                                                      //         onPressed: () {
                                                      //           showCupertinoDialog(
                                                      //             context:
                                                      //                 context,
                                                      //             builder:
                                                      //                 (BuildContext
                                                      //                     context) {
                                                      //               return CupertinoAlertDialog(
                                                      //                 title: Text(
                                                      //                   'Delete client ${data[index]['cli_name']}',
                                                      //                   style: const TextStyle(
                                                      //                       fontFamily:
                                                      //                           'fontOne',
                                                      //                       fontWeight:
                                                      //                           FontWeight.bold),
                                                      //                 ),
                                                      //                 content:
                                                      //                     const Text(
                                                      //                   'This action cannot be undone',
                                                      //                   style:
                                                      //                       TextStyle(
                                                      //                     fontFamily:
                                                      //                         'fontTwo',
                                                      //                   ),
                                                      //                 ),
                                                      //                 actions: <
                                                      //                     Widget>[
                                                      //                   CupertinoDialogAction(
                                                      //                     child:
                                                      //                         const Text(
                                                      //                       'Cancel',
                                                      //                       style:
                                                      //                           TextStyle(color: Colors.blue),
                                                      //                     ),
                                                      //                     onPressed:
                                                      //                         () {
                                                      //                       Navigator.of(context)
                                                      //                           .pop();
                                                      //                     },
                                                      //                   ),
                                                      //                   CupertinoDialogAction(
                                                      //                     child:
                                                      //                         const Text(
                                                      //                       'OK',
                                                      //                       style:
                                                      //                           TextStyle(color: Colors.red),
                                                      //                     ),
                                                      //                     onPressed:
                                                      //                         () {
                                                      //                       setState(
                                                      //                           () {
                                                      //                         showCard =
                                                      //                             false;
                                                      //                       });
                                                      //                       // deleteData(data[index]
                                                      //                       //     [
                                                      //                       //     'id']);
                                                      //                       Navigator.of(context)
                                                      //                           .pop();
                                                      //                     },
                                                      //                   ),
                                                      //                 ],
                                                      //               );
                                                      //             },
                                                      //           );
                                                      //         },
                                                      //         icon: const Icon(
                                                      //           Icons.delete,
                                                      //           color:
                                                      //               Colors.white,
                                                      //         ),
                                                      //         label: const Text(
                                                      //           'DELETE',
                                                      //           style: TextStyle(
                                                      //               fontFamily:
                                                      //                   'fontThree',
                                                      //               color: Colors
                                                      //                   .white,
                                                      //               fontSize: 14),
                                                      //         ),
                                                      //         style: const ButtonStyle(
                                                      //             backgroundColor:
                                                      //                 MaterialStatePropertyAll(
                                                      //                     Colors
                                                      //                         .red)),
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Center(
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: LottieBuilder.asset(
                                              'assets/animations/loading.json')));
                                }
                              },
                            )
                          : Center(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: LottieBuilder.asset(
                                      'assets/animations/loading.json'))),
                    ],
                  ),
                ),
              )
            : Center(
                child: LottieBuilder.asset(
                    'assets/animations/nodata_available.json')),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.blue.shade100,
        //   onPressed: () async {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const MyPmCreateClient(
        //                 caseOperation: 'create', clientID: 0)));
        //   },
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.black,
        //   ),
        // ),
        drawer: const MyAdminDrawyer(),
      ),
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
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       showCupertinoDialog(
                        //         context: context,
                        //         builder: (BuildContext context) {
                        //           return CupertinoAlertDialog(
                        //             title: const Text(
                        //               'Delete remark?',
                        //               style: TextStyle(
                        //                   fontFamily: 'fontOne',
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             content: const Text(
                        //               'This action cannot be undone',
                        //               style: TextStyle(
                        //                 fontFamily: 'fontTwo',
                        //               ),
                        //             ),
                        //             actions: <Widget>[
                        //               CupertinoDialogAction(
                        //                 child: const Text(
                        //                   'Cancel',
                        //                   style: TextStyle(color: Colors.blue),
                        //                 ),
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //               ),
                        //               CupertinoDialogAction(
                        //                 child: const Text(
                        //                   'OK',
                        //                   style: TextStyle(color: Colors.red),
                        //                 ),
                        //                 onPressed: () {
                        //                   deleteRemarks(id);

                        //                   setState(() {
                        //                     getFutureMethodforModal =
                        //                         Stream.fromFuture(
                        //                             getRemarks(testVariable));
                        //                   });
                        //                   Navigator.of(context).pop();
                        //                 },
                        //               ),
                        //             ],
                        //           );
                        //         },
                        //       );
                        //     },
                        //     child: const Text(
                        //       'Delete',
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         color: Colors.red,
                        //       ),
                        //       textAlign: TextAlign.left,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
