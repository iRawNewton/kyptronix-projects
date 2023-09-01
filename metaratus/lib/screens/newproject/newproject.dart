import 'dart:convert';

import 'package:client_onboarding_app/screens/newproject/newprojectpopup.dart';
import 'package:client_onboarding_app/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/string_file.dart';
import '../dashboard/client/colorwidget.dart';
import '../sales/saleswidget.dart';

var tempUrl = AppUrl.hostingerUrl;

class NewProjectRequest extends StatefulWidget {
  const NewProjectRequest({super.key});

  @override
  State<NewProjectRequest> createState() => _NewProjectRequestState();
}

class _NewProjectRequestState extends State<NewProjectRequest> {
  Future<dynamic> getFutureMethod = Future.value();
  dynamic data;
  bool toggleLoading = false;
  String pmId = '';
  Widget hasValue = SizedBox(
    height: 90,
    child: LottieBuilder.asset('assets/animations/loading.json'),
  );
  Future getSalesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    setState(() {
      pmId = pmID.toString();
    });

    var response = await http.post(
        Uri.parse('$tempUrl/sales/newProjectRequest.php'),
        body: {'queryvalue': pmId});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length > 0) {
        setState(() {
          toggleLoading = true;
        });
      } else {
        setState(() {
          toggleLoading = false;
          hasValue =
              LottieBuilder.asset('assets/animations/nodata_available.json');
        });
      }
    }
  }

  @override
  void initState() {
    getFutureMethod = getSalesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Project Request',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
      ),
      body: toggleLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade200,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getFutureMethod,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (data.length > 0) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10),
                                  child: Container(
                                    // height: 150,
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(0, 0, 0, 0.10),
                                      )
                                    ]),
                                    child: Card(
                                      elevation: 0,
                                      color: MyColor.projectCard,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 5, 10),
                                        child: Column(
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Name: ${data[index]['cli_name']}',
                                                    style: TextStyle(
                                                      fontFamily: 'fontTwo',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          MyColor.primaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Contact Info',
                                                  style: TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Expanded(child: Divider()),
                                              ],
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Phone: ${data[index]['phone']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'WhatsApp: ${data[index]['whatsapp']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Email: ${data[index]['email']}',
                                            ),

                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Payment',
                                                  style: TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Expanded(child: Divider()),
                                              ],
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Gross: \$${data[index]['gross']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Net: \$${data[index]['net']}',
                                            ),

                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Dates',
                                                  style: TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Expanded(child: Divider()),
                                              ],
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Date: ${data[index]['date']}',
                                            ),

                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Description: ',
                                                  style: TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Expanded(child: Divider()),
                                              ],
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Package: ${data[index]['package']}',
                                            ),

                                            MySalesWidget(
                                              text:
                                                  'Remarks: ${data[index]['remarks']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Closer Remarks: ${data[index]['closer_remarks']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Business Name: ${data[index]['business_name']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Domain: ${data[index]['domain']}',
                                            ),
                                            // divider

                                            // buttons
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      barrierColor:
                                                          Colors.black54,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return MyNewProjectPopUp(
                                                          id: data[index]['id']
                                                              .toString(),
                                                          email: data[index]
                                                              ['email'],
                                                          gross: data[index]
                                                                  ['gross']
                                                              .toString(),
                                                          paid: data[index]
                                                                  ['net']
                                                              .toString(),
                                                        );
                                                      });
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                  Colors.greenAccent,
                                                )),
                                                child: const Text(
                                                  'Assign',
                                                  style: TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: LottieBuilder.asset(
                                      'assets/animations/loading.json')));
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          : Center(child: hasValue),
      drawer: const MyDrawerInfo(),
    );
  }
}
