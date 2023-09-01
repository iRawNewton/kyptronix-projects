import 'dart:convert';

import 'package:client_onboarding_app/chat/groupchat/groupchatroom.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class GroupChatForDev extends StatefulWidget {
  const GroupChatForDev({super.key});

  @override
  State<GroupChatForDev> createState() => _GroupChatForDevState();
}

class _GroupChatForDevState extends State<GroupChatForDev> {
  dynamic chatData = [];
  String userId = '';
  Map<String, dynamic> userMap = {};

  // *********************** for group chat
  getEmailId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? developerID = prefs.getString('devId');
    setState(() {
      userId = developerID!;
      getUserEmail(userId);
    });
  }

  Future<void> getUserEmail(String emailId) async {
    var response = await http.post(Uri.parse('$tempUrl/groupchat/dev.php'),
        body: {"proj_devid": emailId});
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
            senderName: 'cliName',
            senderUsername: 'cliUsername'),
      ),
    );
  }
  // ***********************

  @override
  void initState() {
    getEmailId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: LottieBuilder.asset('assets/animations/loading.json'))),
    );
  }
}
