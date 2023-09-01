import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class PmDashPopUp extends StatefulWidget {
  const PmDashPopUp({
    super.key,
    required this.pmId,
    required this.type,
  });
  final String pmId;
  final String type;

  @override
  State<PmDashPopUp> createState() => _PmDashPopUpState();
}

class _PmDashPopUpState extends State<PmDashPopUp> {
  dynamic data;
  bool isVisible = false;
  late Future getFutureMethod;

  getPending() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/finance/popupfile.php'),
        body: {
          'pm_id': pmID,
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

  getGross() async {
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/finance/popupfileGross.php'),
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
    if (widget.type == 'pending') {
      getFutureMethod = getPending();
    } else if (widget.type == 'gross') {
      getFutureMethod = getGross();
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
                                          title: Text(data[index]['proj_name']),
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
                                                        'Client: ${data[index]['cli_name']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Gross Amount: \$${data[index]['proj_gross']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Amount Paid: \$${data[index]['proj_paid']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Divider(
                                                        color: Colors.black45,
                                                      ),
                                                      Text(
                                                        'Pending: \$${(double.parse(data[index]['proj_gross']) - double.parse(data[index]['proj_paid'])).toString()}',
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
