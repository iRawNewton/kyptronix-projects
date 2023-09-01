import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class ViewDailyTaskAdmin extends StatefulWidget {
  const ViewDailyTaskAdmin({super.key, required this.devId});

  final String devId;

  @override
  State<ViewDailyTaskAdmin> createState() => _ViewDailyTaskAdminState();
}

class _ViewDailyTaskAdminState extends State<ViewDailyTaskAdmin> {
  var maxlengthline = 10;
  var url = '$tempUrl/updatetask/getDailytask.php';

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

  Widget hasData = SizedBox(
    height: 100,
    child: Center(
      child: LottieBuilder.asset('assets/animations/loading.json'),
    ),
  );

  late Future getFutureData;

  bool visibility = false;

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
    var response = await http.post(Uri.parse(url), body: {
      'dev_id': widget.devId,
      'proj_month': projMonth,
      'proj_year': projYear,
    });

    if (response.statusCode == 200) {
      idata = jsonDecode(response.body);

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
          hasData = Center(
            child:
                LottieBuilder.asset('assets/animations/nodata_available.json'),
          );
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
          'Daily Task',
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
                        child: Scrollbar(
                          radius: const Radius.circular(8.0),
                          thumbVisibility: true,
                          trackVisibility: false,
                          interactive: true,
                          thickness: 8,
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
                                                0.3,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
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
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              data[index]
                                                                  ['name'],
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
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(
                                                              DateFormat(
                                                                      'dd MMMM, yyyy')
                                                                  .format(
                                                                DateTime.parse(
                                                                  data[index][
                                                                      'sentdate'],
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
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        child: const Divider(
                                                          color: Colors.black,
                                                          thickness: 1,
                                                        ),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                              child: Text(
                                                                data[index]
                                                                    ['senttxt'],
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
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(
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
                            },
                          ),
                        ),
                      );
                    })
                : hasData,
          ],
        ),
      ),
    );
  }
}
