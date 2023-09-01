import 'dart:convert';
import 'package:client_onboarding_app/screens/newproject/newproject.dart';
import 'package:client_onboarding_app/screens/newproject/newprojectwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/string_file.dart';
import '../../notification/event_notification.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyNewProjectPopUp extends StatefulWidget {
  const MyNewProjectPopUp({
    super.key,
    required this.id,
    required this.email,
    required this.gross,
    required this.paid,
  });
  final String id;
  final String email;
  final String gross;
  final String paid;

  @override
  State<MyNewProjectPopUp> createState() => _MyNewProjectPopUpState();
}

class _MyNewProjectPopUpState extends State<MyNewProjectPopUp> {
  TextEditingController projectName = TextEditingController();
  TextEditingController projectDesc = TextEditingController();
  TextEditingController projectStartDate = TextEditingController();
  TextEditingController projectEndDate = TextEditingController();
  TextEditingController projectDevId = TextEditingController();
  String pmId = '';
  String clientId = '';
  DateTime date = DateTime.now();
  List devList = [];

  String? dropdownvalue2;
  bool showError = false;
  dynamic deviceData;
  String deviceId = '';

  Future getDevID() async {
    var baseUrl =
        '$tempUrl/ListBox2Developer.php?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        devList = jsonData;
      });
    }
  }

  Future getClientId() async {
    //  var baseUrl =
    //     '$tempUrl/sales/findclientId.php';
    var response =
        await http.post(Uri.parse('$tempUrl/sales/findclientId.php'), body: {
      'queryvalue': widget.email,
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        clientId = jsonData[0]['id'].toString();
      });
    }
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

  getDeviceId(emailId) async {
    var response = await http
        .post(Uri.parse('$tempUrl/notification/customnoti.php'), body: {
      'email_id': emailId,
    });
    if (response.statusCode == 200) {
      deviceData = jsonDecode(response.body);
      setState(() {
        deviceId = deviceData[0]['device_id'];
      });
    }
  }

  sentEmail() async {
    await http.post(Uri.parse('$tempUrl/email/newProject.php'), body: {
      'devId': projectDevId.text,
      'pmId': pmId,
      'subject': 'A new project has been assigned',
      'message':
          '${projectName.text} has been assigned to you. Please check the app for more details.',
    });
  }

// main function
  assignProject(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    setState(() {
      pmId = pmID.toString();
    });

    getDeviceId(projectDevId.text);
    var response =
        await http.post(Uri.parse('$tempUrl/project/createProject.php'), body: {
      'proj_name': projectName.text,
      'proj_desc': projectDesc.text,
      'proj_startdate': projectStartDate.text,
      'proj_enddate': projectEndDate.text,
      'proj_cli_id': clientId,
      'proj_dev_id': projectDevId.text,
      'proj_pm_id': pmId,
      'proj_progress': '0',
      'proj_gross': widget.gross,
      'proj_paid': widget.paid,
    });

    if (response.statusCode == 200) {
      sendCustomNotificationToUser(context, 'New Project',
          'A new project has been assigned to you.', deviceId);
      await http.post(Uri.parse('$tempUrl/sales/deletenewProject.php'), body: {
        'id': widget.id,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewProjectRequest(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Oops something went wrong!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getDevID();
    getClientId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Complete Details to Assign',
          style: TextStyle(
            fontFamily: 'fontTwo',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.36,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyNewProjectWidget(
                  controller: projectName,
                  hintText: 'Project Name',
                  enabled: true,
                ),
                MyNewProjectWidget(
                  controller: projectDesc,
                  hintText: 'Description',
                  enabled: true,
                ),
                InkWell(
                  onTap: () {
                    datePickerFunction(projectStartDate);
                  },
                  child: MyNewProjectWidget(
                    controller: projectStartDate,
                    hintText: 'Start Date',
                    enabled: false,
                  ),
                ),
                InkWell(
                  onTap: () {
                    datePickerFunction(projectEndDate);
                  },
                  child: MyNewProjectWidget(
                      controller: projectEndDate,
                      hintText: 'End Date',
                      enabled: false),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton(
                      dropdownColor: Colors.grey[200],
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'fontThree',
                          color: Colors.black),
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: const Text('Developer Name'),
                      items: devList.map((item) {
                        return DropdownMenuItem(
                          value: item['id'].toString(),
                          child: Text(item['cli_name'].toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          dropdownvalue2 = newVal;
                          projectDevId.text = newVal!;
                        });
                      },
                      value: dropdownvalue2,
                    ),
                  ),
                ),
                showError
                    ? const Text(
                        'Some fields missing details',
                        style: TextStyle(
                          fontFamily: 'fontTwo',
                          color: Colors.redAccent,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.greenAccent,
                  ),
                ),
                onPressed: () {
                  if (projectName.text != '' &&
                      projectDesc.text != '' &&
                      projectStartDate.text != '' &&
                      projectEndDate.text != '' &&
                      projectDevId.text != '') {
                    sentEmail();
                    assignProject(context);
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
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
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'fontTwo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
