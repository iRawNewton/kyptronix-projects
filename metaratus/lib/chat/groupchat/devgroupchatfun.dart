import 'dart:convert';

import 'package:client_onboarding_app/chat/groupchat/groupchatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

getEmailId(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? developerID = prefs.getString('devId');
  getUserEmail(developerID!, context);
}

Future<void> getUserEmail(String emailId, context) async {
  dynamic chatData;

  var response = await http.post(Uri.parse('$tempUrl/groupchat/dev.php'),
      body: {"proj_devid": emailId});
  if (response.statusCode == 200) {
    chatData = jsonDecode(response.body);
  } else {}
  onCustomSearch(chatData[0]['cli_email'], chatData[0]['cli_name'], context);
}

onCustomSearch(senderEmail, senderName, context) async {
  dynamic userMap;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore
      .collection('users')
      .where('email', isEqualTo: senderEmail)
      .get()
      .then((value) {
    // setState(() {
    userMap = value.docs[0].data();
    // });
  });

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
  // goToCustomChatScreen(senderEmail, senderName, context);
}

// goToCustomChatScreen(senderEmail, senderName, context) {
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (_) => GroupChatRoom(
//           senderEmail: senderEmail,
//           chatRoomId: 'DevelopmentTeam',
//           userMap: userMap,
//           currentUsername: senderName,
//           senderName: 'cliName',
//           senderUsername: 'cliUsername'),
//     ),
//   );
// }
