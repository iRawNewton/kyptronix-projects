import 'dart:convert';
import 'package:client_onboarding_app/notification/event_notification.dart';
import 'package:client_onboarding_app/screens/widgets/emailwidget.dart';
import 'package:client_onboarding_app/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyProjectDetails extends StatefulWidget {
  const MyProjectDetails(
      {super.key, required this.caseOperation, required this.projID});
  final String caseOperation;
  final String projID;

  @override
  State<MyProjectDetails> createState() => _MyProjectDetailsState();
}

class _MyProjectDetailsState extends State<MyProjectDetails> {
  TextEditingController projectName = TextEditingController();
  TextEditingController projectDesc = TextEditingController();
  var dateControllerStart = TextEditingController();
  var dateControllerEnd = TextEditingController();
  TextEditingController projectClientID = TextEditingController();
  TextEditingController projectDevId = TextEditingController();
  TextEditingController projectPmId = TextEditingController();
  TextEditingController projectGross = TextEditingController();
  TextEditingController projectPaid = TextEditingController();
  final searchValue = TextEditingController();
  bool isVisible = true;
  bool isDataAvailable = true;
  dynamic data;
  dynamic deviceData;

  DateTime date = DateTime.now();

  List clientList = [];
  List devList = [];
  List pmList = [];

  String deviceId = '';
  String devEmailId = '';

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
    projectRelatedEmail(context, devEmailId, 'New Project',
        'A new project has been assigned. Please Check the app for more details');
  }

  postData(context) async {
    getDeviceId(projectDevId.text);
    var response =
        await http.post(Uri.parse('$tempUrl/project/createProject.php'), body: {
      'proj_name': projectName.text,
      'proj_desc': projectDesc.text,
      'proj_startdate': dateControllerStart.text,
      'proj_enddate': dateControllerEnd.text,
      'proj_cli_id': projectClientID.text,
      'proj_dev_id': projectDevId.text,
      'proj_pm_id': projectPmId.text,
      'proj_progress': '0',
      'proj_gross': projectGross.text,
      'proj_paid': projectPaid.text,
    });

    if (response.statusCode == 200) {
      // notification
      sendCustomNotificationToUser(context, 'New Project',
          'A new project has been assigned to you.', deviceId);

      // email will be sent

      projectName.clear();
      projectDesc.clear();
      dateControllerStart.clear();
      dateControllerEnd.clear();
      projectClientID.clear();
      projectDevId.clear();

      setState(() {
        isDataAvailable = true;
      });

      Navigator.pop(context);
    } else {
      setState(() {
        isDataAvailable = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    }
  }

  searchData(projID) async {
    var response =
        await http.post(Uri.parse('$tempUrl/project/searchProject.php'), body: {
      'searchValue': projID,
    });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      searchValue.text = data[0]['id'].toString();
      projectName.text = data[0]['proj_name'].toString();
      projectDesc.text = data[0]['proj_desc'].toString();
      dateControllerStart.text = data[0]['proj_startdate'].toString();
      dateControllerEnd.text = data[0]['proj_enddate'].toString();

      setState(
        () {
          dropdownvalue1 = data[0]['proj_cli_id'].toString();
          projectClientID.text = data[0]['proj_cli_id'].toString();
          dropdownvalue2 = data[0]['proj_dev_id'].toString();
          projectDevId.text = data[0]['proj_dev_id'].toString();
          dropdownvalue3 = data[0]['proj_pm_id'].toString();
          projectPmId.text = data[0]['proj_pm_id'].toString();
          projectGross.text = data[0]['proj_gross'].toString();
          projectPaid.text = data[0]['proj_paid'].toString();
          isDataAvailable = true;
          isVisible = false;
        },
      );
    } else {
      setState(() {
        isDataAvailable = false;
      });
    }
  }

  updateData(projID, context) async {
    var response =
        await http.post(Uri.parse('$tempUrl/project/updateProject.php'), body: {
      'searchValue': projID,
      'proj_name': projectName.text,
      'proj_desc': projectDesc.text,
      'proj_startdate': dateControllerStart.text,
      'proj_enddate': dateControllerEnd.text,
      'proj_cli_id': projectClientID.text,
      'proj_dev_id': projectDevId.text,
      'proj_pm_id': projectPmId.text,
      'proj_gross': projectGross.text,
      'proj_paid': projectPaid.text
    });

    if (response.statusCode == 200) {
      projectName.clear();
      projectDesc.clear();
      dateControllerStart.clear();
      dateControllerEnd.clear();
      dropdownvalue1 = null;
      dropdownvalue2 = null;
      dropdownvalue3 = null;
      projectClientID.clear();
      projectDevId.clear();
      projectPmId.clear();
      projectGross.clear();
      projectPaid.clear();

      getClientID();
      getDevID();
      getPmID();
      setState(() {
        isDataAvailable = true;
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    }
  }

  deleteData(context) async {
    var response =
        await http.post(Uri.parse('$tempUrl/project/deleteProject.php'), body: {
      'searchValue': searchValue.text,
    });

    if (response.statusCode == 200) {
      projectName.clear();
      projectDesc.clear();
      dateControllerStart.clear();
      dateControllerEnd.clear();
      projectClientID.clear();
      projectDevId.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Success!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    }
  }

  // clientID
  Future getClientID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var baseUrl =
        '$tempUrl/ListBox1Client.php?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    http.Response response = await http.post(Uri.parse(baseUrl), body: {
      'cli_pm': pmID,
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        clientList = jsonData;
      });
    }
  }

  // devID
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

  // pmID
  Future getPmID() async {
    var baseUrl =
        '$tempUrl/ListBox3_.php?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        pmList = jsonData;
      });
    }
  }

  @override
  void initState() {
    getClientID();
    getDevID();
    getPmID();

    if (widget.caseOperation == 'update') {
      searchData(widget.projID);
      setState(() {
        isDataAvailable = false;
      });
    } else if (widget.caseOperation == 'create') {
      setState(() {
        isDataAvailable = true;
      });
    }

    super.initState();
  }

  String? dropdownvalue1;
  String? dropdownvalue2;
  String? dropdownvalue3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kyptronix Projects'),
          centerTitle: true,
        ),
        body: isDataAvailable
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // search
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextField(
                      //           controller: searchValue,
                      //           decoration: const InputDecoration(hintText: 'Search'),
                      //         ),
                      //       ),
                      //       ElevatedButton.icon(
                      //           onPressed: () {
                      //             searchData(context);
                      //             setState(() {
                      //               isVisible = false;
                      //             });
                      //           },
                      //           icon: const Icon(Icons.search),
                      //           label: const Text('Search'))
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20.0),
                      // const Divider(),
                      // const SizedBox(height: 10.0),
                      // Align(
                      //     alignment: Alignment.centerRight,
                      //     child: IconButton(
                      //         onPressed: () {
                      //           projectName.clear();
                      //           projectDesc.clear();
                      //           dateControllerStart.clear();
                      //           dateControllerEnd.clear();
                      //         },
                      //         icon: const Icon(Icons.cancel))),
                      // project name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              keyboardType: TextInputType.text,
                              controller: projectName,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Project Name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // project description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              maxLines: null,
                              keyboardType: TextInputType.text,
                              controller: projectDesc,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Project Description',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // project start date
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              onTap: () {
                                datePickerFunction(dateControllerStart);
                              },
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              maxLines: null,
                              keyboardType: TextInputType.none,
                              controller: dateControllerStart,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Start date',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // project end date
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              onTap: () {
                                datePickerFunction(dateControllerEnd);
                              },
                              maxLines: null,
                              keyboardType: TextInputType.none,
                              controller: dateControllerEnd,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'End date',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // project cli ID
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton(
                            dropdownColor: Colors.grey[200],
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'fontThree',
                                color: Colors.black),
                            underline: const SizedBox(),
                            isExpanded: true,
                            hint: const Text('Client Name'),
                            items: clientList.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['cli_name'].toString()),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue1 = newVal;
                                projectClientID.text = newVal!;
                              });
                            },
                            value: dropdownvalue1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // project dev ID
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
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
                      const SizedBox(height: 10),
                      // project pm ID
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton(
                            dropdownColor: Colors.grey[200],
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'fontThree',
                                color: Colors.black),
                            underline: const SizedBox(),
                            isExpanded: true,
                            hint: const Text('Project Manager'),
                            items: pmList.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['cli_name'].toString()),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue3 = newVal;
                                projectPmId.text = newVal!;
                              });
                            },
                            value: dropdownvalue3,
                          ),
                        ),
                      ),

                      // ***********
                      const SizedBox(height: 10),
                      // project name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              keyboardType: TextInputType.number,
                              controller: projectGross,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Gross Amount',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // project name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'fontThree'),
                              keyboardType: TextInputType.number,
                              controller: projectPaid,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Amount Paid',
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      Visibility(
                        visible: isVisible,
                        replacement: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    isDataAvailable = false;
                                  });
                                  updateData(widget.projID, context);

                                  // setState(() {
                                  //   isVisible = true;
                                  // });
                                },
                                icon: const Icon(
                                  Icons.update,
                                  color: Colors.white,
                                ),
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xff0101D3))),
                                label: const Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'fontTwo',
                                  ),
                                ))),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isDataAvailable = false;
                              });
                              sentEmail(projectDevId.text, context);
                              postData(context);
                            },
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xff0101D3))),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'fontTwo',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child:
                        LottieBuilder.asset('assets/animations/loading.json'))),
        drawer: const MyDrawerInfo(),
      ),
    );
  }
}
