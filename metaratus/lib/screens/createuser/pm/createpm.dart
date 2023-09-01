import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../chat/methods/methods.dart';
import '../../../constant/string_file.dart';
import '../../widgets/adminwidgets.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyNewPm extends StatefulWidget {
  const MyNewPm({super.key});

  @override
  State<MyNewPm> createState() => _MyNewPmState();
}

class _MyNewPmState extends State<MyNewPm> {
  bool notLoading = true;
  final TextEditingController cliname = TextEditingController();
  final TextEditingController cliusername = TextEditingController();
  final TextEditingController clipassword = TextEditingController();
  final TextEditingController cliphone = TextEditingController();
  final TextEditingController cliemail = TextEditingController();

  postData() async {
    // device id
    await http.post(Uri.parse('$tempUrl/notification/createNotify.php'), body: {
      'email_id': cliemail.text,
    });
    var response = await http
        .post(Uri.parse('$tempUrl/projectmanager/createPm.php'), body: {
      'cli_name': cliname.text,
      'cli_username': cliusername.text,
      'cli_password': clipassword.text,
      'cli_phone': cliphone.text,
      'cli_email': cliemail.text,
    });

    if (response.statusCode == 200) {
      createAccount(cliname.text, cliemail.text, clipassword.text);
      cliname.clear();
      cliusername.clear();
      clipassword.clear();
      cliphone.clear();
      cliemail.clear();
      setState(() {
        notLoading = true;
      });
    } else {
      setState(() {
        notLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade50,
          centerTitle: true,
          title: const Text(
            'Create Project Manager',
            style: TextStyle(
              fontFamily: 'fontOne',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: notLoading
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: cliname,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('PM name',
                                  style: TextStyle(
                                    fontFamily: 'fontTwo',
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: cliusername,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('PM username',
                                  style: TextStyle(
                                    fontFamily: 'fontTwo',
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: clipassword,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('PM password',
                                  style: TextStyle(
                                    fontFamily: 'fontTwo',
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: cliphone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('PM phone',
                                  style: TextStyle(
                                    fontFamily: 'fontTwo',
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: cliemail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('PM email',
                                  style: TextStyle(
                                    fontFamily: 'fontTwo',
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.99,
                        height: 40.0,
                        child: ElevatedButton(
                            onPressed: () {
                              if (cliname.text != '' &&
                                  cliusername.text != '' &&
                                  clipassword.text != '' &&
                                  cliphone.text != '' &&
                                  cliemail.text != '') {
                                setState(() {
                                  notLoading = false;
                                });
                                postData();
                              }
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.indigo),
                            ),
                            child: const Text(
                              'save',
                              style: TextStyle(
                                fontFamily: 'fontThree',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: LottieBuilder.asset('assets/animations/loading.json'),
                ),
              ),
        drawer: const MyAdminDrawyer(),
      ),
    );
  }
}
