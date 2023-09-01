import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class ManagerProfileDialog extends StatefulWidget {
  const ManagerProfileDialog({
    super.key,
    required this.pmId,
    required this.type,
  });
  final String pmId;
  final String type;

  @override
  State<ManagerProfileDialog> createState() => _ManagerProfileDialogState();
}

class _ManagerProfileDialogState extends State<ManagerProfileDialog> {
  dynamic data;
  bool isVisible = false;

  getProjectList() async {
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/projectProfileInfo.php'),
        body: {
          'pm_id': widget.pmId,
        });

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        setState(() {
          data = jsonDecode(response.body);
          isVisible = true;
        });
      } else {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    getProjectList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      actions: [
        const SizedBox(height: 30),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Project Lists',
                  style: TextStyle(
                    fontFamily: 'fontTwo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                isVisible
                    ? FutureBuilder(
                        future: getProjectList(),
                        builder: (context, snapshot) {
                          {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return (data[index]['proj_status'] ==
                                          widget.type)
                                      ? Card(
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 10,
                                            ),
                                            child:
                                                Text(data[index]['proj_name']),
                                          ))
                                      : const SizedBox();
                                });
                          } //else {
                          //   return Center(
                          //       child: LottieBuilder.asset(
                          //           'assets/animation/not_found.json'));
                          // }
                        },
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.19,
                            child: LottieBuilder.asset(
                                'assets/animations/not_found.json'),
                          ),
                          const Text(
                            'Waiting for data...',
                            style: TextStyle(fontFamily: 'fontTwo'),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ******************** finance
class ManagerProfileDialogFinance extends StatefulWidget {
  const ManagerProfileDialogFinance({
    super.key,
    required this.pmId,
    required this.type,
  });
  final String pmId;
  final String type;

  @override
  State<ManagerProfileDialogFinance> createState() =>
      _ManagerProfileDialogFinanceState();
}

class _ManagerProfileDialogFinanceState
    extends State<ManagerProfileDialogFinance> {
  dynamic data;
  bool isVisible = false;
  late Future getFutureMethod;

  getProjectList() async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;

    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/pmprofilemonthinfo.php'),
        body: {
          'pm_id': widget.pmId,
          'month': currentMonth.toString(),
        });

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        setState(() {
          data = jsonDecode(response.body);
          isVisible = true;
        });
      } else {
        setState(() {});
      }
    }
  }

  getProjectLisTotal() async {
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/pmprofiletotalinfo.php'),
        body: {
          'pm_id': widget.pmId,
        });

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        setState(() {
          data = jsonDecode(response.body);
          isVisible = true;
        });
      } else {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    if (widget.type == 'month') {
      setState(() {
        getFutureMethod = getProjectList();
      });
    } else if (widget.type == 'total') {
      setState(() {
        getFutureMethod = getProjectLisTotal();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      actions: [
        const SizedBox(height: 30),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Project Lists',
                  style: TextStyle(
                    fontFamily: 'fontTwo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                isVisible
                    ? FutureBuilder(
                        future: getFutureMethod,
                        builder: (context, snapshot) {
                          {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 10,
                                        ),
                                        child: ExpansionTile(
                                          title: Text(DateFormat(
                                                  'dd, MMMM yyyy')
                                              .format(DateTime.parse(
                                                  data[index]['paymentDate']))),
                                          children: [
                                            Card(
                                              elevation: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 1.0),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Client: ${data[index]['projectName']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Project: ${data[index]['proj_name']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Amount Paid: \$${data[index]['amountPaid']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                });
                          } //else {
                          //   return Center(
                          //       child: LottieBuilder.asset(
                          //           'assets/animation/not_found.json'));
                          // }
                        },
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.19,
                            child: LottieBuilder.asset(
                                'assets/animations/not_found.json'),
                          ),
                          const Text(
                            'Waiting for data...',
                            style: TextStyle(fontFamily: 'fontTwo'),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
