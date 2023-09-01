import 'dart:convert';

import 'package:client_onboarding_app/screens/sales/salespopup.dart';
import 'package:client_onboarding_app/screens/sales/saleswidget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constant/string_file.dart';
import '../dashboard/client/colorwidget.dart';
import '../widgets/adminwidgets.dart';
import 'package:http/http.dart' as http;

var tempUrl = AppUrl.hostingerUrl;

class MySales extends StatefulWidget {
  const MySales({super.key});

  @override
  State<MySales> createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  Future<dynamic> getFutureMethod = Future.value();
  dynamic data;
  bool toggleLoading = false;
  Widget hasValue = SizedBox(
      height: 90, child: LottieBuilder.asset('assets/animations/loading.json'));

  Future getSalesList() async {
    // var response = await http.post(Uri.parse('$tempUrl/sales/sales.php'));
    var response = await http
        .post(Uri.parse('https://crm.kyptronix.in/api_fetch_data.php'));

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
          'Sales List',
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
                                                    'Name: ${data[index]['name']}',
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
                                            MySalesWidget(
                                              text:
                                                  'Address: ${data[index]['address']}',
                                            ),
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
                                            MySalesWidget(
                                              text:
                                                  'Pending: ${data[index]['pending']}',
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
                                            MySalesWidget(
                                              text:
                                                  'Month: ${data[index]['month']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Year: ${data[index]['year']}',
                                            ),
                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Remarks',
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
                                                  'Remarks: ${data[index]['remark']}',
                                            ),
                                            const SizedBox(height: 10),
                                            MySalesWidget(
                                              text:
                                                  'Closer Remarks: ${data[index]['closer_remark']}',
                                            ),
                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Other Info',
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
                                                  'Close: ${data[index]['close']}',
                                            ),

                                            MySalesWidget(
                                              text:
                                                  'Business Consult: ${data[index]['business_consult']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Business Name: ${data[index]['business_name']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Domain: ${data[index]['domain']}',
                                            ),

                                            // buttons
                                            const SizedBox(height: 20),
                                            Visibility(
                                              visible:
                                                  data[index]['assign'] == '0'
                                                      ? true
                                                      : false,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 2.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              barrierColor:
                                                                  Colors
                                                                      .black54,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return MySalesPopUp(
                                                                    id: data[index]
                                                                        ['id'],
                                                                    clientName:
                                                                        data[index][
                                                                            'name'],
                                                                    phone: data[index][
                                                                        'phone'],
                                                                    email: data[index][
                                                                        'email'],
                                                                    whatsapp:
                                                                        data[index][
                                                                            'whatsapp'],
                                                                    package: data[index][
                                                                        'package'],
                                                                    gross: data[index][
                                                                        'gross'],
                                                                    net: data[index]
                                                                        ['net'],
                                                                    date: data[index][
                                                                        'date'],
                                                                    remarks:
                                                                        data[index]
                                                                            ['remark'],
                                                                    closerRemarks: data[index]['closer_remark'],
                                                                    businessName: data[index]['business_name'],
                                                                    domainName: data[index]['domain']);
                                                              });
                                                        },
                                                        style:
                                                            const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                          Colors.greenAccent,
                                                        )),
                                                        child: const Text(
                                                          'Assign',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(
                                                  //           left: 2.0),
                                                  //   child: SizedBox(
                                                  //     width:
                                                  //         MediaQuery.of(context)
                                                  //                 .size
                                                  //                 .width *
                                                  //             0.42,
                                                  //     child: ElevatedButton(
                                                  //       onPressed: () {
                                                  //         showDialog(
                                                  //             context: context,
                                                  //             builder:
                                                  //                 (BuildContext
                                                  //                     context) {
                                                  //               return MySalesDeclinePopUp(
                                                  //                   id: data[
                                                  //                           index]
                                                  //                       ['id']);
                                                  //             });
                                                  //       },
                                                  //       style: const ButtonStyle(
                                                  //           backgroundColor:
                                                  //               MaterialStatePropertyAll(
                                                  //         Colors.redAccent,
                                                  //       )),
                                                  //       child: const Text(
                                                  //         'Decline',
                                                  //         style: TextStyle(
                                                  //           fontFamily: 'fontTwo',
                                                  //           fontWeight:
                                                  //               FontWeight.bold,
                                                  //           color: Colors.white,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),

                                            // SingleChildScrollView(
                                            //   scrollDirection: Axis.horizontal,
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.start,
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.start,
                                            //     children: [
                                            //       Align(
                                            //         alignment: Alignment.centerLeft,
                                            //         child: Text(
                                            //           'Total: ${data[index]['proj_gross']}',
                                            //           style: TextStyle(
                                            //             fontFamily: 'fontTwo',
                                            //             fontSize: 18,
                                            //             fontWeight: FontWeight.bold,
                                            //             color: MyColor.primaryText,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       const SizedBox(width: 10),
                                            //       Align(
                                            //         alignment: Alignment.centerLeft,
                                            //         child: Text(
                                            //           'Paid: ${data[index]['proj_paid']}',
                                            //           style: TextStyle(
                                            //             fontFamily: 'fontTwo',
                                            //             fontSize: 18,
                                            //             fontWeight: FontWeight.bold,
                                            //             color: MyColor.primaryText,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       const SizedBox(width: 10),
                                            //       Align(
                                            //         alignment: Alignment.centerLeft,
                                            //         child: Text(
                                            //           'Balance: ${data[index]['balance']}',
                                            //           style: TextStyle(
                                            //             fontFamily: 'fontTwo',
                                            //             fontSize: 18,
                                            //             fontWeight: FontWeight.bold,
                                            //             color: MyColor.primaryText,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),

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
      drawer: const MyAdminDrawyer(),
    );
  }
}
