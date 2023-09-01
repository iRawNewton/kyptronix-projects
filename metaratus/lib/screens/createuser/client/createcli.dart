import 'dart:convert';

import 'package:client_onboarding_app/screens/list/clientlist.dart';
import 'package:client_onboarding_app/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/methods/methods.dart';
import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyPmCreateClient extends StatefulWidget {
  const MyPmCreateClient(
      {super.key, required this.caseOperation, required this.clientID});
  final String caseOperation;
  final String clientID;
  @override
  State<MyPmCreateClient> createState() => _MyPmCreateClientState();
}

class _MyPmCreateClientState extends State<MyPmCreateClient> {
  // var maxlengthline = 10;
  bool isVisible = true;
  bool isDataAvailable = true;
  final id = TextEditingController();
  final cliId = TextEditingController();
  final cliPass = TextEditingController();
  final cliName = TextEditingController();
  final cliEmail = TextEditingController();
  final cliPhone = TextEditingController();
  final cliWhatsapp = TextEditingController();
  final cliDesignation = TextEditingController();
  final searchValue = TextEditingController();
  dynamic data;
  String pmId = '';
  bool editData = true;

  postData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    setState(() {
      pmId = pmID.toString();
    });
    // device id
    await http.post(Uri.parse('$tempUrl/notification/createNotify.php'), body: {
      'email_id': cliEmail.text,
    });
    // main details
    var response =
        await http.post(Uri.parse('$tempUrl/client/createClient.php'), body: {
      'cli_userid': cliId.text,
      'cli_pass': cliPass.text,
      'cli_name': cliName.text,
      'cli_email': cliEmail.text,
      'cli_phone': cliPhone.text,
      'cli_whatsapp': cliWhatsapp.text,
      'cli_designation': cliDesignation.text,
      'cli_manager_id': pmId,
    });

    if (response.statusCode == 200) {
      createAccount(cliName.text, cliEmail.text, cliPass.text);
      cliId.clear();
      cliPass.clear();
      cliName.clear();
      cliEmail.clear();
      cliPhone.clear();
      cliDesignation.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MyClientList(),
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

  searchData(String clientId) async {
    var response =
        await http.post(Uri.parse('$tempUrl/client/editClientInfo.php'), body: {
      'queryvalue': clientId.toString(),
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      id.text = data[0]['id'].toString();
      cliId.text = data[0]['cli_userid'].toString();
      cliPass.text = data[0]['cli_pass'].toString();
      cliName.text = data[0]['cli_name'].toString();
      cliEmail.text = data[0]['cli_email'].toString();
      cliPhone.text = data[0]['cli_phone'].toString();
      cliWhatsapp.text = data[0]['cli_whatsapp'].toString();
      cliDesignation.text = data[0]['cli_designation'].toString();
      setState(() {
        editData = false;
        isDataAvailable = true;
        isVisible = false;
      });
    } else {
      setState(() {
        isDataAvailable = false;
      });
    }
  }

  updateData(context) async {
    var response =
        await http.post(Uri.parse('$tempUrl/client/updateClient.php'), body: {
      'id': id.text,
      'cli_userid': cliId.text,
      'cli_pass': cliPass.text,
      'cli_name': cliName.text,
      'cli_email': cliEmail.text,
      'cli_phone': cliPhone.text,
      'cli_whatsapp': cliWhatsapp.text,
      'cli_designation': cliDesignation.text,
    });
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MyClientList(),
        ),
      );
      setState(() {
        isVisible = true;
      });

      cliId.clear();
      cliPass.clear();
      cliName.clear();
      cliEmail.clear();
      cliPhone.clear();
      cliWhatsapp.clear();
      cliDesignation.clear();
      searchValue.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error!'),
        ),
      );
    }
  }

  // deleteData(context) async {
  //   var response = await http.post(
  //       Uri.parse(
  //           '$tempUrl/client/deleteClient.php'),
  //       body: {
  //         'id': id.text,
  //       });
  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text('Success!'),
  //       ),
  //     );

  //     cliId.clear();
  //     cliPass.clear();
  //     cliName.clear();
  //     cliEmail.clear();
  //     cliPhone.clear();
  //     cliDesignation.clear();
  //     searchValue.clear();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text('Error!'),
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    cliId.dispose();
    cliPass.dispose();
    cliName.dispose();
    cliEmail.dispose();
    cliPhone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.caseOperation == 'update') {
      searchData(widget.clientID);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          title: const Text('Kyptronix Client Account'),
          centerTitle: true,
        ),
        body: isDataAvailable
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),

                      // const SizedBox(height: 10.0),
                      // Align(
                      //     alignment: Alignment.centerRight,
                      //     child: IconButton(
                      //         onPressed: () {
                      //           cliId.clear();
                      //           cliPass.clear();
                      //           cliName.clear();
                      //           cliEmail.clear();
                      //           cliPhone.clear();
                      //           cliDesignation.clear();
                      //           setState(() {
                      //             isVisible = true;
                      //           });
                      //         },
                      //         icon: const Icon(Icons.cancel))),
                      // client ID
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
                              controller: cliId,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                counterText: '',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                              enabled: editData,
                              controller: cliPass,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                              controller: cliName,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Full Name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                              enabled: editData,
                              controller: cliEmail,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email ID',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                              keyboardType: TextInputType.phone,
                              controller: cliPhone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                              keyboardType: TextInputType.phone,
                              controller: cliWhatsapp,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Whatsapp',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                              controller: cliDesignation,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Designation',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      Visibility(
                        visible: isVisible,
                        replacement: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.indigo)),
                                onPressed: () {
                                  if (id.text != '' &&
                                      cliId.text != '' &&
                                      cliPass.text != '' &&
                                      cliName.text != '' &&
                                      cliEmail.text != '' &&
                                      cliPhone.text != '' &&
                                      cliWhatsapp.text != '' &&
                                      cliDesignation.text != '') {
                                    setState(() {
                                      isDataAvailable = false;
                                    });
                                    updateData(context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            icon: Icon(
                                              Icons.warning_rounded,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                            title: Text(
                                              'One or more text field empty',
                                              style: TextStyle(
                                                fontFamily: 'fontOne',
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                                icon: const Icon(
                                  Icons.update,
                                  color: Colors.white,
                                ),
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
                              if (cliId.text != '' &&
                                  cliPass.text != '' &&
                                  cliName.text != '' &&
                                  cliEmail.text != '' &&
                                  cliPhone.text != '' &&
                                  cliWhatsapp.text != '' &&
                                  cliDesignation.text != '') {
                                setState(() {
                                  isDataAvailable = false;
                                });
                                postData(context);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        icon: Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        title: Text(
                                          'One or more text field empty',
                                          style: TextStyle(
                                            fontFamily: 'fontOne',
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xff0101D3))),
                            child: const Text(
                              'Create client account',
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
