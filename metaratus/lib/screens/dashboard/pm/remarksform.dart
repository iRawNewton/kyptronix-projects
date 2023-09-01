import 'dart:convert';

import 'package:client_onboarding_app/notification/event_notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../constant/string_file.dart';
import '../../widgets/emailwidget.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyPmRemarksForm extends StatefulWidget {
  const MyPmRemarksForm({super.key, required this.projectID});

  final String projectID;

  @override
  State<MyPmRemarksForm> createState() => _MyPmRemarksFormState();
}

class _MyPmRemarksFormState extends State<MyPmRemarksForm> {
  // variables
  TextEditingController dateField = TextEditingController();
  TextEditingController remarksField = TextEditingController();
  TextEditingController linkField = TextEditingController();

  DateTime date = DateTime.now();
  List deviceId = [];
  List projectName = [];
  String devId = '';
  String cliId = '';
  String devEmailId = '';

  bool loadingScreen = true;
  Widget loadingCircle = LottieBuilder.asset('assets/animations/loading.json');

  sentEmail(devId, pmId, projectName) async {
    await http.post(Uri.parse('$tempUrl/email/newProject.php'), body: {
      'devId': devId,
      'pmId': pmId,
      'subject': 'New Remarks',
      'message':
          'Manager has given remarks in $projectName. Please check app for more details.',
    });
  }

  postData(context, projectID) async {
    // for notification
    var responseNotificationDeviceID = await http
        .post(Uri.parse('$tempUrl/notification/getDeviceIdDev.php'), body: {
      'project_id': projectID,
    });

    var responseNotificationProjectName = await http.post(
        Uri.parse('$tempUrl/notification/getProjectNameForNotification.php'),
        body: {
          'project_id': projectID,
        });

    if (responseNotificationDeviceID.statusCode == 200) {
      setState(() {
        deviceId = jsonDecode(responseNotificationDeviceID.body);
      });
    }

    if (responseNotificationProjectName.statusCode == 200) {
      setState(() {
        projectName = jsonDecode(responseNotificationProjectName.body);
      });
    }
    sendCustomNotificationToUser(
        context,
        'Project remarks updated',
        'New remark has been added in ${projectName[0]['proj_name']}',
        deviceId[0]['device_id']);

    // get dev ID
    var getDevCliId =
        await http.post(Uri.parse('$tempUrl/remarks/getDevId.php'), body: {
      'project_id': projectID,
    });

    if (getDevCliId.statusCode == 200) {
      dynamic results = jsonDecode(getDevCliId.body);
      setState(() {
        devId = results[0]['proj_dev_id'].toString();
        cliId = results[0]['proj_cli_id'].toString();
      });
    }

    sentEmail(String id, context) async {
      var response =
          await http.post(Uri.parse('$tempUrl/email/newProject.php'), body: {
        'email_id': id,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          devEmailId = data[0]['cli_email'];
        });
      }
      projectRelatedEmail(context, devEmailId, 'Remarks Added',
          'Remarks has been added to ${projectName[0]['proj_name']}. Please check app for more info.');
    }

    sentEmail(devId, context);

    // end dev id
    var response =
        await http.post(Uri.parse('$tempUrl/remarks/insertRemarks.php'), body: {
      'cli_date': dateField.text,
      'cli_projid': projectID,
      'remarks_by': 'manager',
      'cli_task': remarksField.text,
      'proj_links': linkField.text,
      'devId': devId,
      'cliId': cliId,
      'projName': projectName[0]['proj_name'],
    });
    if (response.statusCode == 200) {
      setState(() {
        dateField.clear();
        remarksField.clear();
        linkField.clear();
      });
      Navigator.pop(context);
    } else {}
  }

  void datePickerFunction(dateController) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2025),
    ).then(
      (value) {
        setState(() {
          date = value!;
          final formatter = DateFormat('dd/MM/yyyy');
          final formatteddate = formatter.format(date);
          dateController.text = formatteddate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Remarks',
            style:
                TextStyle(fontFamily: 'fontOne', fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: loadingScreen
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      // date
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextField(
                        readOnly: true,
                        controller: dateField,
                        decoration: InputDecoration(
                            labelText: 'Date',
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 0, 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black),
                            )),
                        style: const TextStyle(
                          fontFamily: 'fontTwo',
                        ),
                        onTap: () {
                          datePickerFunction(dateField);
                        },
                      ),

                      // remarks
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        controller: remarksField,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: 'Remarks',
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 0, 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black),
                            )),
                        style: const TextStyle(
                          fontFamily: 'fontTwo',
                        ),
                      ),

                      // proj links
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextField(
                        controller: linkField,
                        decoration: InputDecoration(
                            labelText: 'Link',
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 0, 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black),
                            )),
                        style: const TextStyle(
                          fontFamily: 'fontTwo',
                        ),
                      ),

                      // button
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
                        child: ElevatedButton.icon(
                            icon: const Icon(Icons.save, color: Colors.white),
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.indigo.shade400),
                            ),
                            onPressed: () {
                              setState(() {
                                loadingScreen = false;
                              });
                              postData(context, widget.projectID);
                            },
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                  fontFamily: 'fontThree',
                                  color: Colors.white,
                                  fontSize: 16),
                            )),
                      )
                    ],
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: loadingCircle,
                  ),
                ),
        ),
      ),
    );
  }
}
