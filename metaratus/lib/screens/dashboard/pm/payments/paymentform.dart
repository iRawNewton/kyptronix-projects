import 'dart:convert';

import 'package:client_onboarding_app/screens/dashboard/pm/pm_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class CollectionForm extends StatefulWidget {
  const CollectionForm({super.key});

  @override
  State<CollectionForm> createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController projectList = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController grossAmount = TextEditingController();
  TextEditingController netAmount = TextEditingController();
  TextEditingController addAmount = TextEditingController();
  bool validateText = false;

  DateTime date = DateTime.now();
  List projList = [];
  String? dropdownvalue;
  double earlierPaid = 0;

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

  Future getProjectName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var baseUrl =
        '$tempUrl/payment/getProjectNamesNew.php?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    http.Response response =
        await http.post(Uri.parse(baseUrl), body: {'proj_pm_id': pmID});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        projList = jsonData;
      });
    }
  }

  Future getClientName(cliId) async {
    var baseUrl =
        '$tempUrl/payment/getClientNames.php?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    http.Response response =
        await http.post(Uri.parse(baseUrl), body: {'proj_cli_id': cliId});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        clientName.text = jsonData[0]['cli_name'];
        grossAmount.text = jsonData[0]['proj_gross'].toString();
        netAmount.text = jsonData[0]['proj_paid'].toString();
        earlierPaid = double.parse(jsonData[0]['proj_paid'].toString());
        // String projPaidString = jsonData[0]['proj_paid'].toString();

        // print(double.parse(projPaidString));
      });
    }
  }

  postData(context) async {
    String x = '${netAmount.text} dollars has been paid by ${clientName.text}';
    // main details
    var response =
        await http.post(Uri.parse('$tempUrl/payment/newPayment.php'), body: {
      'paymentDate': dateController.text,
      'projectId': projectList.text,
      'projectName': clientName.text,
      'totalAmount': grossAmount.text,
      'amountPaid': addAmount.text,
      'totalPaid': netAmount.text,
      'paymentBody': x,
    });

    if (response.statusCode == 200) {
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
    getProjectName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.13,
      child: Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.60,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  const Text(
                    'Daily Collection',
                    style: TextStyle(
                      fontFamily: 'fontOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Divider(),
                  // date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          onTap: () {
                            datePickerFunction(dateController);
                          },
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'fontThree'),
                          maxLines: null,
                          keyboardType: TextInputType.none,
                          controller: dateController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Date of Payment',
                          ),
                        ),
                      ),
                    ),
                  ),
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
                          hint: const Text('Project Name'),
                          items: projList.map((item) {
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(item['proj_name'].toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                              projectList.text = newVal!;
                              getClientName(projectList.text);
                            });
                          },
                          value: dropdownvalue,
                        ),
                      ),
                    ),
                  ),
                  // client name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'fontThree'),
                          maxLines: null,
                          keyboardType: TextInputType.none,
                          controller: clientName,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Client Name',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // gross amount
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'fontThree'),
                          maxLines: null,
                          keyboardType: TextInputType.none,
                          controller: grossAmount,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Gross Amount',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // net amount
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'fontThree'),
                          maxLines: null,
                          keyboardType: TextInputType.none,
                          controller: netAmount,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Net Amount',
                            errorText: validateText
                                ? 'Number exceeds gross amount'
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // add amount
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          onChanged: (value) {
                            // int netAmountValue =
                            //     int.tryParse(netAmount.text) ?? 0;
                            double addAmountValue =
                                double.tryParse(addAmount.text) ?? 0;
                            double result = earlierPaid + addAmountValue;
                            // if (result > double.parse(grossAmount.text)) {
                            //   setState(() {
                            //     validateText = true;
                            //   });
                            // } else {
                            //   setState(() {
                            //     validateText = false;
                            //   });
                            //   // focusTextField.unfocus();
                            // }
                            netAmount.text = result.toString();
                          },
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'fontThree'),
                          maxLines: null,
                          keyboardType: TextInputType.number,
                          controller: addAmount,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add Amount',
                          ),
                        ),
                      ),
                    ),
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
                            if (dateController.text != '' &&
                                clientName.text != '' &&
                                grossAmount.text != '' &&
                                addAmount.text != '' &&
                                grossAmount.text != '') {
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
        ),
      ),
    );
  }
}
