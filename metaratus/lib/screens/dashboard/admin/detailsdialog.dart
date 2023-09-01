import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class AdminShowDialog extends StatefulWidget {
  const AdminShowDialog({
    super.key,
    required this.devId,
    required this.phone,
    required this.whatsapp,
    required this.email,
  });
  final String devId;
  final String phone;
  final String whatsapp;
  final String email;

  @override
  State<AdminShowDialog> createState() => _AdminShowDialogState();
}

class _AdminShowDialogState extends State<AdminShowDialog> {
  dynamic data;
  bool isVisible = false;

  getProjectList() async {
    var response = await http.post(
        Uri.parse('$tempUrl/project/projectDetailsforAdmin/getProjectList.php'),
        body: {
          'dev_id': widget.devId.toString(),
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
                                  return Theme(
                                    data: ThemeData().copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      textColor: Colors.black,
                                      collapsedTextColor: Colors.blue.shade800,
                                      iconColor: Colors.black,
                                      collapsedIconColor: Colors.blue.shade800,
                                      title: Text(
                                        data[index]['proj_name'],
                                        style: const TextStyle(
                                          fontFamily: 'fontTwo',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      children: [
                                        Card(
                                          elevation: 0,
                                          color: Colors.grey.shade200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 10.0),
                                            child: Column(
                                              children: [
                                                // date labels
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Start Date',
                                                      style: TextStyle(
                                                        fontFamily: 'fontTwo',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'End Date',
                                                      style: TextStyle(
                                                        fontFamily: 'fontTwo',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // date values
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      DateFormat('dd MMM, yyyy')
                                                          .format(
                                                        DateTime.parse(data[
                                                                index]
                                                            ['proj_startdate']),
                                                      ),
                                                      style: const TextStyle(
                                                        fontFamily: 'fontTwo',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('dd MMM, yyyy')
                                                          .format(DateTime
                                                              .parse(data[index]
                                                                  [
                                                                  'proj_enddate'])),
                                                      style: const TextStyle(
                                                        fontFamily: 'fontTwo',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // client name
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Client: ${data[index]['cli_name']}',
                                                    style: const TextStyle(
                                                      fontFamily: 'fontTwo',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                // progress
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Progress: ${data[index]['proj_progress']}',
                                                    style: const TextStyle(
                                                      fontFamily: 'fontTwo',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
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
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Contact Developer',
                        style: TextStyle(
                          fontFamily: 'fontTwo',
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: IconButton(
                        onPressed: () {
                          void launchCall(number) async {
                            final Uri phoneNumber = Uri.parse('tel:$number');
                            launchUrl(phoneNumber);
                          }

                          launchCall(widget.phone);
                        },
                        icon: Image.asset(
                          'assets/images/call.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: IconButton(
                        onPressed: () {
                          void launchWhatsApp(number) async {
                            final Uri whatsApp =
                                Uri.parse('https://wa.me/$number?');
                            launchUrl(whatsApp,
                                mode: LaunchMode.externalApplication);
                          }

                          launchWhatsApp(widget.whatsapp);
                        },
                        icon: Image.asset(
                          'assets/images/whatsapp.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: IconButton(
                        onPressed: () {
                          void launchEmail(number) async {
                            final Uri email = Uri(
                              scheme: 'mailto',
                              path: widget.email,
                              queryParameters: {},
                            );
                            launchUrl(email,
                                mode: LaunchMode.externalApplication);
                          }

                          launchEmail(widget.email);
                        },
                        icon: Image.asset(
                          'assets/images/gmail.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
