import 'dart:convert';

import 'package:client_onboarding_app/screens/dashboard/pm/pm_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../constant/string_file.dart';
import '../../widgets/emailwidget.dart';

var tempUrl = AppUrl.hostingerUrl;

class ChangeDev extends StatefulWidget {
  const ChangeDev({super.key, required this.projectId});
  final String projectId;

  @override
  State<ChangeDev> createState() => _ChangeDevState();
}

class _ChangeDevState extends State<ChangeDev> {
  TextEditingController devName = TextEditingController();
  TextEditingController progressIndicator = TextEditingController();

  bool validateText = false;

  DateTime date = DateTime.now();
  List devList = [];
  String? dropdownvalue;
  double progressValue = 0;
  bool xLoading = true;
  String devEmailId = '';

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
    // main details
    var response = await http
        .post(Uri.parse('$tempUrl/projectmanager/updateDeveloper.php'), body: {
      'proj_id': widget.projectId,
      'dev_id': devName.text,
      'proj_progress': progressIndicator.text,
    });

    if (response.statusCode == 200) {
      setState(() {
        xLoading = true;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyPmDashboard()));
      // todo here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    }
  }

  @override
  void initState() {
    getDevID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.13,
      child: Dialog(
        child: xLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        const Text(
                          'Developer Name',
                          style: TextStyle(
                            fontFamily: 'fontOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Divider(),

                        // project list
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: DropdownButton(
                                elevation: 0,
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
                                    dropdownvalue = newVal;
                                    devName.text = newVal!;
                                  });
                                },
                                value: dropdownvalue,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Card(
                            elevation: 0,
                            child: StepProgressIndicator(
                              totalSteps: 100,
                              currentStep: progressValue.toInt(),
                              size: 50,
                              padding: 0,
                              // selectedColor: Colors.greenAccent.shade700,
                              // unselectedColor: Colors.red,
                              roundedEdges: const Radius.circular(10),
                              selectedGradientColor: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.greenAccent.shade700,
                                  Colors.green
                                ],
                              ),
                              unselectedGradientColor: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Colors.blue.shade100],
                              ),
                            ),
                          ),
                        ),
                        Slider(
                          inactiveColor: Colors.white,
                          activeColor: const Color(0xffFDA615),
                          value: progressValue,
                          min: 0.0,
                          max: 100.0,
                          divisions: 100,
                          onChanged: (double value) {
                            setState(() {
                              progressValue = value;
                              progressIndicator.text = progressValue.toString();
                            });
                          },
                          label: progressValue.toInt().toString(),
                        ),

                        // button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Colors.blue.shade300,
                                  ),
                                ),
                                onPressed: () {
                                  if (devName.text != '') {
                                    setState(() {
                                      xLoading = false;
                                    });
                                    sentEmail(devName.text, context);
                                    postData(context);
                                  }
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontFamily: 'fontThree',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 100,
                child: LottieBuilder.asset('assets/animations/loading.json'),
              ),
      ),
    );
  }
}
