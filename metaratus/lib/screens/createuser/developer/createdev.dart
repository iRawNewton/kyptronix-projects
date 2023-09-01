import 'dart:convert';

import 'package:client_onboarding_app/screens/dashboard/pm/send_new_emp_email.dart';
import 'package:client_onboarding_app/screens/list/developerlist.dart';
import 'package:client_onboarding_app/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../chat/methods/methods.dart';
import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyDevNewUser extends StatefulWidget {
  const MyDevNewUser(
      {super.key, required this.caseOperation, required this.devID});

  final String caseOperation;
  final String devID;

  @override
  State<MyDevNewUser> createState() => _MyDevNewUserState();
}

class _MyDevNewUserState extends State<MyDevNewUser> {
  final username = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phone = TextEditingController();
  final whatsapp = TextEditingController();
  final email = TextEditingController();
  final designation = TextEditingController();
  final emailPassword = TextEditingController();
  final searchValue = TextEditingController();
  dynamic data;
  bool isVisible = true;
  bool isDataAvailable = true;

  postData(context) async {
    // device id
    await http.post(Uri.parse('$tempUrl/notification/createNotify.php'), body: {
      'email_id': email.text,
    });
    // main details
    var response =
        await http.post(Uri.parse('$tempUrl/dev/createdev.php'), body: {
      'cli_username': username.text,
      'cli_password': password.text,
      'cli_name': fullname.text,
      'cli_phone': phone.text,
      'cli_whatsapp': whatsapp.text,
      'cli_email': email.text,
      'cli_designation': designation.text,
      'cli_emailPassword': emailPassword.text,
    });

    if (response.statusCode == 200) {
      createAccount(fullname.text, email.text, password.text);
      sendEmailToNewEmployee(
        context,
        email,
        'kyptronix.dev@gmail.com',
        fullname,
      );
      username.clear();
      password.clear();
      fullname.clear();
      phone.clear();
      whatsapp.clear();
      email.clear();
      designation.clear();
      emailPassword.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MyDevList(),
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

  searchData(String devId) async {
    var response =
        await http.post(Uri.parse('$tempUrl/dev/editDevInfo.php'), body: {
      'searchValue': devId,
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      searchValue.text = data[0]['id'].toString();
      username.text = data[0]['cli_username'].toString();
      password.text = data[0]['cli_password'].toString();
      fullname.text = data[0]['cli_name'].toString();
      phone.text = data[0]['cli_phone'].toString();
      whatsapp.text = data[0]['cli_whatsapp'].toString();
      email.text = data[0]['cli_email'].toString();
      designation.text = data[0]['cli_designation'].toString();
      emailPassword.text = data[0]['email_password'].toString();
      setState(() {
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
        await http.post(Uri.parse('$tempUrl/dev/updatedev.php'), body: {
      'searchValue': searchValue.text,
      'cli_username': username.text,
      'cli_password': password.text,
      'cli_name': fullname.text,
      'cli_phone': phone.text,
      'cli_whatsapp': whatsapp.text,
      'cli_email': email.text,
      'cli_designation': designation.text,
      'cli_emailPassword': emailPassword.text,
    });

    if (response.statusCode == 200) {
      username.clear();
      password.clear();
      fullname.clear();
      phone.clear();
      whatsapp.clear();
      email.clear();
      designation.clear();
      emailPassword.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MyDevList(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error one or more fields empty!'),
        ),
      );
    }
  }

  @override
  void initState() {
    if (widget.caseOperation == 'update') {
      searchData(widget.devID);
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
          backgroundColor: Colors.blue.shade50,
          title: const Text('Kyptronix Development Team'),
          centerTitle: true,
        ),
        body: isDataAvailable
            ? Container(
                height: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),

                      // username
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: username,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // password
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: password,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // name
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: fullname,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Full Name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // phone
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone No.',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // whatsapp
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: whatsapp,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'WhatsApp No.',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // email
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: email,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email ID',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // designation
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: designation,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Designation',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                              ),
                              onPressed: () {
                                setState(() {
                                  designation.text = 'Developer';
                                });
                              },
                              child: const Text(
                                'Developer',
                                style: TextStyle(
                                  fontFamily: 'fontThree',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                              ),
                              onPressed: () {
                                setState(() {
                                  designation.text = 'Graphic Designer';
                                });
                              },
                              child: const Text(
                                'Graphic Designer',
                                style: TextStyle(
                                  fontFamily: 'fontThree',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                              ),
                              onPressed: () {
                                setState(() {
                                  designation.text = 'SMO';
                                });
                              },
                              child: const Text(
                                'SMO',
                                style: TextStyle(
                                  fontFamily: 'fontThree',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                              ),
                              onPressed: () {
                                setState(() {
                                  designation.text = 'SEO';
                                });
                              },
                              child: const Text(
                                'SEO',
                                style: TextStyle(
                                  fontFamily: 'fontThree',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                              ),
                              onPressed: () {
                                setState(() {
                                  designation.text = 'Digital Marketing Expert';
                                });
                              },
                              child: const Text(
                                'Digital Marketing Expert',
                                style: TextStyle(
                                  fontFamily: 'fontThree',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // email password
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: emailPassword,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // elevatedbutton
                      const SizedBox(height: 50),
                      Visibility(
                        visible: isVisible,
                        replacement: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  if (username.text != '' &&
                                      password.text != '' &&
                                      fullname.text != '' &&
                                      phone.text != '' &&
                                      whatsapp.text != '' &&
                                      email.text != '' &&
                                      designation.text != '') {
                                    setState(() {
                                      isDataAvailable = false;
                                    });
                                    updateData(context);
                                    setState(() {
                                      isVisible = true;
                                    });
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
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.indigo)),
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
                              if (username.text != '' &&
                                  password.text != '' &&
                                  fullname.text != '' &&
                                  phone.text != '' &&
                                  whatsapp.text != '' &&
                                  email.text != '' &&
                                  designation.text != '') {
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
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.indigo)),
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
