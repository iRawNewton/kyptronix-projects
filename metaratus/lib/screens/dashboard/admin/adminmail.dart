import 'dart:convert';
import 'package:client_onboarding_app/screens/dashboard/admin/emailwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyAdminEmail extends StatefulWidget {
  const MyAdminEmail({super.key});

  @override
  State<MyAdminEmail> createState() => _MyAdminEmailState();
}

class _MyAdminEmailState extends State<MyAdminEmail> {
  TextEditingController toAddress = TextEditingController();
  TextEditingController ccAddress = TextEditingController();
  TextEditingController bccAddress = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController body = TextEditingController();
  final HtmlEditorController controller = HtmlEditorController();
  dynamic data;
  bool xLoading = false;
  late Future getMethod;
  getEmailContact() async {
    var response =
        await http.post(Uri.parse('$tempUrl/admin/email/getEmailList.php'));
    if (response.statusCode == 200) {
      setState(() {
        xLoading = true;
        data = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      getMethod = getEmailContact();
    });
    super.initState();
  }

  Future<void> sendEmailAdminPm(
      context, toText, ccText, bccText, subject, body) async {
    try {
      var userEmail = 'kyptronix@gmail.com';
      var message = Message();
      message.subject = subject.text;
      // summary
      message.html = body.text;

      // message.html = 'This is test body';
      message.from = Address(userEmail.toString(), 'Souvik Karmakar');

      // receipents
      List<String> emails = toText.text.split(',');
      List<Address> recipients = [];
      for (String email in emails) {
        recipients.add(Address(email.trim()));
      }
      message.recipients = recipients;

      // cc receipents
      List<String> ccEmails = ccText.text.split(',');
      List<Address> ccRecipient = [];
      if (ccEmails.isNotEmpty) {
        for (String ccEmail in ccEmails) {
          recipients.add(Address(ccEmail.trim()));
        }
        message.ccRecipients = ccRecipient;
      }

      // bcc receipents
      List<String> bccEmails = bccText.text.split(',');
      List<Address> bccRecipient = [];
      if (bccText.isNotEmpty) {
        for (String bccEmail in bccEmails) {
          recipients.add(Address(bccEmail.trim()));
        }
        message.bccRecipients = bccRecipient;
      }

      var smtpServer = gmail(userEmail, 'cnasttaokkyfzsug');
      send(message, smtpServer).then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: const Text(
              'Email sent',
              style: TextStyle(
                fontFamily: 'fontTwo',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green.shade400,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        );
        /* 
      (
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: const Text(
              'Email sent',
              style: TextStyle(
                fontFamily: 'fontTwo',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green.shade400,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
      ) */
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(
              fontFamily: 'fontTwo',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.width;
    // var y = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade50,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade200],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmailWidget(
                labelText: 'To',
                controller: toAddress,
                textInputType: TextInputType.emailAddress,
                textLines: null,
              ),
              const SizedBox(height: 20),
              EmailWidget(
                labelText: 'Cc',
                controller: ccAddress,
                textInputType: TextInputType.emailAddress,
                textLines: 1,
              ),
              const SizedBox(height: 20),
              EmailWidget(
                labelText: 'Bcc',
                controller: bccAddress,
                textInputType: TextInputType.emailAddress,
                textLines: 1,
              ),
              xLoading
                  ? FutureBuilder(
                      future: getMethod,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (data.length > 0) {
                          return SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (bccAddress.text.isEmpty) {
                                            bccAddress.text =
                                                data[index]['cli_email'];
                                          } else {
                                            bccAddress.text +=
                                                ', ${data[index]['cli_email']}';
                                          }
                                        },
                                      );
                                    },
                                    child: Text(
                                      '${data[index]['cli_name']}',
                                      style: TextStyle(
                                        fontFamily: 'fontTwo',
                                        fontSize: x * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: const Text('No Email Found')));
                        }
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              EmailWidget(
                labelText: 'Subject',
                controller: subject,
                textInputType: TextInputType.emailAddress,
                textLines: 1,
              ),
              const SizedBox(height: 20),
              // html editor
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Body',
                    style: TextStyle(
                      fontFamily: 'fontThree',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: HtmlEditor(
                    controller: controller,
                    htmlEditorOptions: const HtmlEditorOptions(
                      hint: "Your text here...",
                      autoAdjustHeight: true,
                    ),
                    htmlToolbarOptions: const HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.belowEditor,
                        toolbarType: ToolbarType.nativeScrollable,
                        defaultToolbarButtons: [
                          StyleButtons(),
                          FontButtons(
                            subscript: false,
                            superscript: false,
                            clearAll: false,
                          ),
                          FontSettingButtons(),
                          ParagraphButtons(
                            textDirection: false,
                            caseConverter: false,
                          ),
                          ColorButtons(),
                          ListButtons(),
                          OtherButtons(
                            codeview: false,
                            fullscreen: false,
                            help: false,
                            copy: false,
                            paste: false,
                            undo: true,
                            redo: true,
                          )
                        ]),
                    otherOptions: const OtherOptions(
                      height: 500.0,
                    ),
                  ),
                ),
              ),
              // html editor
              // EmailWidget(
              //   labelText: 'Body',
              //   controller: body,
              //   textInputType: TextInputType.multiline,
              //   textLines: 10,
              // ),
              const SizedBox(height: 30),
              // used to convert html to text
              // ElevatedButton(
              //     onPressed: () async {
              //       var txt = await controller.getText();
              //       setState(() {
              //         body.text = txt;
              //       });
              //     },
              //     child: const Text('check text')),
              // const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () async {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );

                    var txt = await controller.getText();
                    setState(() {
                      body.text = txt;
                      sendEmailAdminPm(
                        context,
                        toAddress,
                        ccAddress,
                        bccAddress,
                        subject,
                        body,
                      );
                    });

                    // toAddress.clear();
                    // ccAddress.clear();
                    // bccAddress.clear();
                    // subject.clear();
                    // body.clear();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Send Email',
                        style: TextStyle(
                            fontFamily: 'fontThree',
                            color: Colors.white,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.send,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // drawer: const MyAdminDrawyer(),
    );
  }
}
