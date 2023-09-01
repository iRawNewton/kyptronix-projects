// two function exist here
import 'dart:convert';
import 'package:client_onboarding_app/screens/sales/salesmain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../chat/methods/methods.dart';
import '../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MySalesPopUp extends StatefulWidget {
  const MySalesPopUp({
    super.key,
    required this.id,
    required this.clientName,
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.package,
    required this.gross,
    required this.net,
    required this.date,
    required this.remarks,
    required this.closerRemarks,
    required this.businessName,
    required this.domainName,
  });

  final String id;
  final String clientName;
  final String phone;
  final String email;
  final String whatsapp;
  final String package;
  final String gross;
  final String net;
  final String date;
  final String remarks;
  final String closerRemarks;
  final String businessName;
  final String domainName;

  @override
  State<MySalesPopUp> createState() => _MySalesPopUpState();
}

class _MySalesPopUpState extends State<MySalesPopUp> {
  List pmList = [];
  TextEditingController projectPmId = TextEditingController();
  String? dropdownvalue3;
  bool showError = false;

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

// main function
  Future assignProject(context) async {
    var response =
        await http.post(Uri.parse('$tempUrl/sales/newProject.php'), body: {
      'id': widget.id,
      'cli_name': widget.clientName,
      'phone': widget.phone,
      'email': widget.email,
      'whatsapp': widget.whatsapp,
      'package': widget.package,
      'gross': widget.gross,
      'net': widget.net,
      'date': widget.date,
      'remarks': widget.remarks,
      'closer_remarks': widget.closerRemarks,
      'business_name': widget.businessName,
      'domain': widget.domainName,
      'pm_id': projectPmId.text
    });
    if (response.statusCode == 200) {
      // update sales to 1
      var responseSales = await http.post(
        Uri.parse(
            'https://crm.kyptronix.in/api_filter_sale.php?assign=1&id=${widget.id}'),
      );
      if (responseSales.statusCode == 200) {
        createAccount(widget.clientName, widget.email, 'Kyptronix2023');

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MySales()));
      }

      // update sales to 1
    } else {}
  }

  @override
  void initState() {
    getPmID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'To Confirm Select Project Manager',
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
          height: MediaQuery.of(context).size.height * 0.1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                showError
                    ? const Text(
                        'No Project Manager Selected',
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
                  if (projectPmId.text != '') {
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

// for decline -----------------------------------------------

class MySalesDeclinePopUp extends StatefulWidget {
  const MySalesDeclinePopUp({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<MySalesDeclinePopUp> createState() => _MySalesDeclinePopUpState();
}

class _MySalesDeclinePopUpState extends State<MySalesDeclinePopUp> {
  bool showError = false;

// main function
  Future deleteProject(context) async {
    var response =
        await http.post(Uri.parse('$tempUrl/sales/deleteSales.php'), body: {
      'id': widget.id,
    });

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MySales()));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              'Warning',
              style: TextStyle(
                fontFamily: 'fontTwo',
                fontWeight: FontWeight.bold,
                color: Colors.redAccent.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      content: const Text(
        'Deleted Sales can\'t be Recovered!',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
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
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'fontTwo',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  deleteProject(context);
                },
                child: const Text(
                  'Decline',
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
