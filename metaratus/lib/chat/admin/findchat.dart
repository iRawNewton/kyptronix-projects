import 'dart:convert';
import 'package:client_onboarding_app/chat/admin/viewchats.dart';
import 'package:client_onboarding_app/constant/string_file.dart';
import 'package:client_onboarding_app/screens/widgets/adminwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyAdminChatFind extends StatefulWidget {
  const MyAdminChatFind({super.key});

  @override
  State<MyAdminChatFind> createState() => MyAdminChatFindState();
}

class MyAdminChatFindState extends State<MyAdminChatFind> {
  List clientList = [];
  List pmList = [];
  TextEditingController projectClientID = TextEditingController();
  TextEditingController projectPmID = TextEditingController();
  String? dropdownvalue1;
  String? dropdownvalue2;
  dynamic data;
  String emailid = '';

  // clientID
  Future getClientID() async {
    var tempUrl = AppUrl.hostingerUrl;
    var baseUrl = '$tempUrl/admin/chat/client.php';
    var response = await http.post(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        clientList = jsonData;
      });
    }
  }

  // pmID
  Future getPmID() async {
    var tempUrl = AppUrl.hostingerUrl;
    var baseUrl = '$tempUrl/admin/chat/pmlist22.php';
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        pmList = jsonData;
      });
    }
  }

  // get email
  getEmailID(String name) async {
    var tempUrl = AppUrl.hostingerUrl;
    var response =
        await http.post(Uri.parse('$tempUrl/admin/chat/getEmail.php'), body: {
      'queryvalue': name,
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      setState(() {
        emailid = data[0]['cli_email'];
      });
      onSearch(emailid);
    }
  }

  // for chat
  Map<String, dynamic> userMap = {};
  final FirebaseAuth auth = FirebaseAuth.instance;
  String senderEmail = '';
  String roomID = '';
  bool isLoading = false;

  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  // pass sender email ID
  onSearch(senderEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .where('email', isEqualTo: senderEmail)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
    setState(() {
      roomID = chatRoomId(projectPmID.text, projectClientID.text);
      isLoading = false;
    });
    goToChatScreen();
  }

  goToChatScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatView(
            chatRoomId: roomID,
            userMap: userMap,
            currentUsername: projectClientID.text,
            senderName: projectPmID.text,
            senderUsername: projectPmID.text),
      ),
    );
  }

  @override
  void initState() {
    getClientID();
    getPmID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(fontFamily: 'fontOne', fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Card(
              color: Colors.blue.shade50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // pm
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
                        hint: const Text('Manager Name'),
                        items: pmList.map((item) {
                          return DropdownMenuItem(
                            value: item['manager_name'].toString(),
                            child: Text(item['manager_name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            dropdownvalue1 = newVal;
                            projectPmID.text = newVal!;
                          });
                        },
                        value: dropdownvalue1,
                      ),
                    ),
                  ),

                  // client
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
                            value: item['cli_name'].toString(),
                            child: Text(item['cli_name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            dropdownvalue2 = newVal;
                            projectClientID.text = newVal!;
                          });
                        },
                        value: dropdownvalue2,
                      ),
                    ),
                  ),
                  // const SizedBox(height: ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue.shade400)),
                        onPressed: () {
                          getEmailID(projectPmID.text);
                          // print(emailid);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.security_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              'View Chats',
                              style: TextStyle(
                                fontFamily: 'fontThree',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: const MyAdminDrawyer(),
    );
  }
}
