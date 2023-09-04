import 'dart:convert';
import 'package:client_onboarding_app/screens/assignproject/developer/auth_dev.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyDevProjectDetails extends StatefulWidget {
  const MyDevProjectDetails({super.key});

  @override
  State<MyDevProjectDetails> createState() => _MyDevProjectDetailsState();
}

class _MyDevProjectDetailsState extends State<MyDevProjectDetails> {
  var maxlengthline = 10;
  var url = '$tempUrl/project/ShowDevProjectDetails.php';

  dynamic data;

  postData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    String devID = developerID.toString();
    var response = await http.post(Uri.parse(url), body: {
      'proj_dev_id': devID,
    });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade50,
        title: const Text(
          'Your Project List',
          style: TextStyle(
              fontFamily: 'fontOne', fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.amber.shade50,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: FutureBuilder(
            future: postData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: LottieBuilder.asset(
                              'assets/animations/loading.json'))),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              title: const Text(
                                                'Overall Project Description',
                                                style: TextStyle(
                                                  fontFamily: 'fontOne',
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Project Description: ${data[index]['proj_desc']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 20.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Starting Date: ${data[index]['proj_startdate']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Ending Date: ${data[index]['proj_enddate']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('Continue'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.15),
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                          offset: const Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                        color: Colors.amber.shade100,
                                        elevation: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  data[index]['proj_name'],
                                                  style: const TextStyle(
                                                    fontFamily: 'fontOne',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // description
                                                  const Text(
                                                    'Desciption: ',
                                                    style: TextStyle(
                                                      fontFamily: 'fontTwo',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  Flexible(
                                                      child: Text(
                                                    data[index]['proj_desc'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: const TextStyle(
                                                      fontFamily: 'fontTwo',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              Text(
                                                'Start Date: ${DateFormat('dd MMMM, yyyy').format(
                                                  DateTime.parse(
                                                    data[index]
                                                        ['proj_startdate'],
                                                  ),
                                                )}',
                                                style: const TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Text(
                                                'End Date: ${DateFormat('dd MMMM, yyyy').format(
                                                  DateTime.parse(
                                                    data[index]['proj_enddate'],
                                                  ),
                                                )}',
                                                style: const TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10.0),
                                              // ElevatedButton(
                                              //   onPressed: () {
                                              //     Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             AuthQuestionaire(
                                              //           developerIdTemp:
                                              //               data[index]
                                              //                   ['proj_cli_id'],
                                              //         ),
                                              //       ),
                                              //     );
                                              //     // Navigator.push(
                                              //     //   context,
                                              //     //   MaterialPageRoute(
                                              //     //     builder: (context) =>
                                              //     //         QuestionDev(
                                              //     //       id: data[index]
                                              //     //           ['proj_cli_id'],
                                              //     //     ),
                                              //     //   ),
                                              //     // );
                                              //   },
                                              //   child: const Text(
                                              //     'View questionnaire',
                                              //     style: TextStyle(
                                              //         color: Colors.black87,
                                              //         fontSize: 14.0),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              // ListTile(
                              //   textColor: Colors.white,
                              //   tileColor: Colors.black,
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(5)),
                              //   iconColor: Colors.white,
                              //   // leading: Text('ID:${data[index]['proj_dev_id']}'),
                              //   title: Text(data[index]['proj_name']),
                              //   subtitle: Text(
                              //     data[index]['proj_desc'],
                              //     overflow: TextOverflow.fade,
                              //     maxLines: 2,
                              //   ),
                              //   trailing: IconButton(
                              //       onPressed: () {
                              //         showDialog(
                              //             context: context,
                              //             builder: (context) => AlertDialog(
                              //                   title: const Text(
                              //                       'Overall Project Description'),
                              //                   content: Column(
                              //                     children: [
                              //                       Align(
                              //                         alignment: Alignment
                              //                             .centerLeft,
                              //                         child: Text(
                              //                           'Project Description: ${data[index]['proj_desc']}',
                              //                           textAlign: TextAlign
                              //                               .justify,
                              //                         ),
                              //                       ),
                              //                       const SizedBox(
                              //                           height: 20.0),
                              //                       Align(
                              //                         alignment: Alignment
                              //                             .centerLeft,
                              //                         child: Text(
                              //                           'Starting Date: ${data[index]['proj_startdate']}',
                              //                           textAlign: TextAlign
                              //                               .justify,
                              //                         ),
                              //                       ),
                              //                       const SizedBox(
                              //                           height: 10.0),
                              //                       Align(
                              //                         alignment: Alignment
                              //                             .centerLeft,
                              //                         child: Text(
                              //                           'Ending Date: ${data[index]['proj_enddate']}',
                              //                           textAlign: TextAlign
                              //                               .justify,
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                   actions: [
                              //                     TextButton(
                              //                       style: TextButton
                              //                           .styleFrom(
                              //                         textStyle:
                              //                             Theme.of(context)
                              //                                 .textTheme
                              //                                 .labelLarge,
                              //                       ),
                              //                       child: const Text(
                              //                           'Continue'),
                              //                       onPressed: () {
                              //                         Navigator.of(context)
                              //                             .pop();
                              //                       },
                              //                     ),
                              //                   ],
                              //                 ));
                              //       },
                              //       icon: const Icon(
                              //           Icons.arrow_forward_ios)),
                              // ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
