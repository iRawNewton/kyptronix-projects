import 'dart:convert';

import 'package:client_onboarding_app/chat/groupchat/groupchatroom.dart';
import 'package:client_onboarding_app/screens/createuser/client/createcli.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/string_file.dart';
import '../chatroom/chatscreen.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyChatList extends StatefulWidget {
  const MyChatList({super.key});

  @override
  State<MyChatList> createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
  var url = '$tempUrl/client/getEntireClientList.php';

  dynamic data = [];
  dynamic chatData = [];
  String userId = '';
  // for calling
  String currentUsername = '';
  String cliName = '';
  String cliUsername = '';
  TextEditingController searchValue = TextEditingController();
  Future<dynamic> getFutureMethod = Future.value();

  Future<void> getClientList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    var response = await http.post(Uri.parse(url), body: {'pm_id': pmID});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {}
  }

  Future<void> getCustomClientList(customValue) async {
    var response = await http.post(
        Uri.parse(
            '$tempUrl/searchClient.php?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
        body: {
          'queryvalue': customValue.text,
        });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {}
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
      roomID = chatRoomId(auth.currentUser!.displayName!, userMap['name']);
      isLoading = false;
    });
    goToChatScreen(senderEmail);
  }

  goToChatScreen(senderEmail) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoom(
            senderEmail: senderEmail,
            chatRoomId: roomID,
            userMap: userMap,
            currentUsername: currentUsername,
            senderName: cliName,
            senderUsername: cliUsername),
      ),
    );
  }

  // *********************** for group chat
  getEmailId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');
    setState(() {
      userId = pmID!;
      getUserEmail(userId);
    });
  }

  Future<void> getUserEmail(String emailId) async {
    var response = await http.post(Uri.parse('$tempUrl/groupchat/manager.php'),
        body: {"proj_managerid": emailId});
    if (response.statusCode == 200) {
      chatData = jsonDecode(response.body);
    } else {}
    onCustomSearch(chatData[0]['cli_email'], chatData[0]['cli_name']);
  }

  onCustomSearch(senderEmail, senderName) async {
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
    // setState(() {
    //   roomIDGroup = chatRoomId(auth.currentUser!.displayName!, userMap['name']);
    //   isLoading = false;
    // });
    goToCustomChatScreen(senderEmail, senderName);
  }

  goToCustomChatScreen(senderEmail, senderName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GroupChatRoom(
            senderEmail: senderEmail,
            chatRoomId: 'DevelopmentTeam',
            userMap: userMap,
            currentUsername: senderName,
            senderName: senderName,
            senderUsername: 'cliUsername'),
      ),
    );
  }

  // ***********************
  @override
  void initState() {
    getFutureMethod = getClientList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client List',
          style: TextStyle(fontFamily: 'fontOne', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Card(
                    elevation: 0,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchValue,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Search'),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green.shade500),
                      ),
                      onPressed: () {
                        setState(() {
                          getFutureMethod = getCustomClientList(searchValue);
                        });
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          fontFamily: 'fontThree',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                )
              ],
            ),
            FutureBuilder(
                future: getFutureMethod,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (data.length == 0) {
                    return SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            LottieBuilder.asset(
                                'assets/animations/not_found.json'),
                            const Text(
                              'Uhh Oh! No client found',
                              style: TextStyle(
                                  fontFamily: 'fontTwo',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 40.0),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MyPmCreateClient(
                                                caseOperation: 'create',
                                                clientID: '0'),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Create new client user',
                                    style: TextStyle(
                                        fontFamily: 'fontThree', fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                                senderEmail =
                                    data[index]['cli_email'].toString();
                                // for calling
                                currentUsername = 'usermanager';
                                cliName = data[index]['cli_name'].toString();
                                cliUsername =
                                    data[index]['cli_userid'].toString();
                              });

                              onSearch(senderEmail);

                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (_) => ChatRoom(
                              //         chatRoomId: roomID, userMap: userMap),
                              //   ),
                              // );
                            },
                            child: Card(
                              color: Colors.blue.shade100,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(width: 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index]['cli_name'].toString(),
                                        ),
                                        Text(data[index]['cli_phone']
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: Colors.grey.shade100),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade100,
        onPressed: () async {
          getEmailId();
        },
        child: const Icon(Icons.group_rounded),
      ),
    );
  }
}
