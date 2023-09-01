import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class ViewDailyPayment extends StatefulWidget {
  const ViewDailyPayment({super.key});

  @override
  State<ViewDailyPayment> createState() => _ViewDailyPaymentState();
}

class _ViewDailyPaymentState extends State<ViewDailyPayment> {
  var maxlengthline = 10;
  var url = '$tempUrl/payment/paymentList.php';

  dynamic data;
  dynamic idata;
  TextEditingController taskDoneUpdate = TextEditingController();
  TextEditingController projectTitleUpdate = TextEditingController();
  TextEditingController projectID = TextEditingController();
  TextEditingController progressIndicator = TextEditingController();
  // date variable
  dynamic initialDate;
  String iProjectMonth = '';
  String iProjectYear = '';
  String projectMonth = '';
  String projectYear = '';

  List projectList = [];
  double progressValue = 0;
  bool noData = false;
  late Future getFutureData;

  bool visibility = false;
  int sum = 0;
  String sumValue = '';

  datePickerFunction() {
    initialDate = DateTime.now();
    final monthFormatter = DateFormat('MMMM');
    final yearFormatter = DateFormat('yyyy');
    final month = DateFormat('MM');
    final year = DateFormat('yyyy');
    setState(() {
      iProjectMonth = monthFormatter.format(initialDate);
      iProjectYear = yearFormatter.format(initialDate);
      projectMonth = month.format(initialDate);
      projectYear = year.format(initialDate);
    });
    getFutureData = postData(projectMonth, projectYear);
  }

  decrementMonth() {
    // subtract 1 from the current month
    int previousMonth = initialDate.month - 1;
    int year = initialDate.year;

    if (previousMonth < 1) {
      // if the previous month is December of the previous year
      previousMonth = 12;
      year--;
    }

    // create a new DateTime object with the updated month and year
    initialDate = DateTime(year, previousMonth, initialDate.day);
    setState(() {
      final monthFormatter = DateFormat('MMMM');
      final yearFormatter = DateFormat('yyyy');
      final month = DateFormat('MM');
      final year = DateFormat('yyyy');
      iProjectMonth = monthFormatter.format(initialDate);
      iProjectYear = yearFormatter.format(initialDate);
      projectMonth = month.format(initialDate);
      projectYear = year.format(initialDate);
      getFutureData = postData(projectMonth, projectYear);
    }); // update the UI
  }

  void incrementMonth() {
    // add 1 to the current month
    int nextMonth = initialDate.month + 1;
    int year = initialDate.year;

    if (nextMonth > 12) {
      // if the next month is January of the next year
      nextMonth = 1;
      year++;
    }

    // create a new DateTime object with the updated month and year
    initialDate = DateTime(year, nextMonth, initialDate.day);
    setState(() {
      final monthFormatter = DateFormat('MMMM');
      final yearFormatter = DateFormat('yyyy');
      final month = DateFormat('MM');
      final year = DateFormat('yyyy');
      iProjectMonth = monthFormatter.format(initialDate);
      iProjectYear = yearFormatter.format(initialDate);
      projectMonth = month.format(initialDate);
      projectYear = year.format(initialDate);
      getFutureData = postData(projectMonth, projectYear);
    });
  }

  postData(String projMonth, String projYear) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');

    sum = 0;
    var response = await http.post(Uri.parse(url), body: {
      'proj_month': projMonth,
      'proj_year': projYear,
      'pm_id': pmID,
    });

    if (response.statusCode == 200) {
      idata = jsonDecode(response.body);

      for (int i = 0; i < idata.length; i++) {
        int amountPaid = int.parse(idata[i]['amountPaid']);
        sum += amountPaid;
      }
      setState(() {
        sumValue = sum.toString();
      });

      if (idata.length != 0) {
        data = jsonDecode(response.body);
        setState(() {
          visibility = true;
          noData = true;
        });
      } else {
        setState(() {
          visibility = true;
          noData = false;
        });
      }
    } else {}
  }

  String? dropdownvalue1;

  @override
  void initState() {
    datePickerFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text(
          'Daily Payment',
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
              Colors.blue.shade50,
              Colors.lightBlue.shade100,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      visibility = false;
                    });
                    decrementMonth();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                Text(
                  '$iProjectMonth, $iProjectYear',
                  style: const TextStyle(fontFamily: 'fontOne'),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      visibility = false;
                    });
                    incrementMonth();
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
            noData
                ? FutureBuilder(
                    future: getFutureData,
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return (visibility)
                                ? Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 15.0),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.15),
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: const Offset(0,
                                                    4), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: Colors.blue.shade200,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10.0),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 8.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMMM, yyyy')
                                                                .format(
                                                              DateTime.parse(
                                                                data[index][
                                                                    'paymentDate'],
                                                              ),
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'fontTwo',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 30,
                                                              child:
                                                                  VerticalDivider(
                                                                color: Colors
                                                                    .black,
                                                                thickness: 2,
                                                              )),
                                                          Text(
                                                            data[index]
                                                                ['proj_name'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'fontTwo',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      child: const Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'Total Amount: ${data[index]['totalAmount']}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'fontTwo',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              // overflow: TextOverflow.fade,
                                                              maxLines: null,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'Last amount received: ${data[index]['amountPaid']}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'fontTwo',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              // overflow: TextOverflow.fade,
                                                              maxLines: null,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'Net Amount: ${data[index]['totalPaid']}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'fontTwo',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              // overflow: TextOverflow.fade,
                                                              maxLines: null,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: LottieBuilder.asset(
                                            'assets/animations/loading.json')));
                          },
                        ),
                      );
                    })
                : Center(
                    child: LottieBuilder.network(
                        'https://assets4.lottiefiles.com/packages/lf20_rjn0esjh.json'),
                  ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blue.shade50),
        child: Center(
            child: Text(
          'Total: \$$sumValue',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * 0.018,
          ),
        )),
      ),
    );
  }
}
