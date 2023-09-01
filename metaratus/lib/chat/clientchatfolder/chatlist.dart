import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../constant/string_file.dart';
import '../chatroom/chatscreen.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyClientChatList extends StatefulWidget {
  const MyClientChatList({super.key, required this.clientIdForChat});
  final String clientIdForChat;

  @override
  State<MyClientChatList> createState() => _MyClientChatListState();
}

class _MyClientChatListState extends State<MyClientChatList> {
  var url = '$tempUrl/client/getEntireListForChat.php';

  dynamic data = [];
  // for calling
  String currentUsername = '';
  String cliName = '';
  String cliUsername = '';

  Future<void> getPmList(id) async {
    var response =
        await http.post(Uri.parse(url), body: {'queryvalue': id.toString()});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact List',
          style: TextStyle(fontFamily: 'fontOne', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            FutureBuilder(
                future: getPmList(widget.clientIdForChat),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (data.length == 0) {
                    return SizedBox(
                      child: Column(
                        children: [
                          LottieBuilder.asset(
                              'assets/animations/not_found.json'),
                        ],
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
                            },
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              iconColor: Colors.black,
                              tileColor: Colors.amber,
                              title: Text(
                                data[index]['cli_name'].toString(),
                              ),
                              subtitle:
                                  Text(data[index]['cli_phone'].toString()),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(color: Colors.grey),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
