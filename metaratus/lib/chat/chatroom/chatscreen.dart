import 'dart:convert';
// import 'package:client_onboarding_app/calling/call_invitation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:http/http.dart' as http;

import '../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.chatRoomId,
    required this.userMap,
    required this.currentUsername,
    required this.senderUsername,
    required this.senderName,
    required this.senderEmail,
  });

  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final String currentUsername;
  final String senderUsername;
  final String senderName;
  final String senderEmail;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? mtoken = '';

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby': _auth.currentUser!.displayName,
        'message': _message.text,
        'time': FieldValue.serverTimestamp(),
      };
      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      debugPrint('enter some text');
    }
  }

// for notification
  dynamic data;
  final TextEditingController deviceIdController = TextEditingController();
  getDeviceId() async {
    var response = await http
        .post(Uri.parse('$tempUrl/notification/getDeviceId.php'), body: {
      'email_id': widget.senderEmail,
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      setState(() {
        deviceIdController.text = data[0]['device_id'];
      });
    } else {}
  }

  Future<void> sendNotificationToUser(String title, String content) async {
    // create a notification with the given player ID as the target
    var notification = OSCreateNotification(
      playerIds: [deviceIdController.text],
      content: content, // content
      heading: widget.senderName, // title
      androidSound: 'iphone_sound',
      androidChannelId: '38aa8271-8a48-4936-8ca6-a6f1d0b674f9',
      additionalData: {'category': 'KyptronixDemo'},
    );
    await OneSignal.shared.postNotification(notification);
  }

  @override
  void initState() {
    getDeviceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // removed CallInvitationPage that has wrapped safe area and had username: widget.currentUsername,
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Colors.lightBlue.shade100,
          title: Text(
            widget.userMap['name'],
            style: const TextStyle(
                fontFamily: 'fontOne',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          // actions: [
          //   ZegoSendCallInvitationButton(
          //     icon: ButtonIcon(
          //         icon: const Icon(
          //           Icons.call,
          //           color: Colors.black,
          //         ),
          //         backgroundColor: Colors.lightBlue.shade300),
          //     isVideoCall: false,
          //     resourceID: "zegouikit_call",
          //     notificationTitle: 'Kyptronix LLP',
          //     notificationMessage: 'Incoming Call',
          //     invitees: [
          //       ZegoUIKitUser(
          //         id: widget.senderUsername,
          //         name: widget.senderName,
          //       ),
          //     ],
          //   ),
          //   ZegoSendCallInvitationButton(
          //     icon: ButtonIcon(
          //         icon: const Icon(
          //           Icons.videocam,
          //           color: Colors.black,
          //         ),
          //         backgroundColor: Colors.lightBlue.shade300),
          //     isVideoCall: true,
          //     resourceID: "zegouikit_call",
          //     notificationTitle: 'Kyptronix LLP',
          //     notificationMessage: 'Incoming Call',
          //     invitees: [
          //       ZegoUIKitUser(
          //         id: widget.senderUsername,
          //         name: widget.senderName,
          //       ),
          //     ],
          //   ),
          // ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade100,
                Colors.white70,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 1.25,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chatroom')
                        .doc(widget.chatRoomId)
                        .collection('chats')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return messages(size, map);
                            });
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  height: size.height / 10,
                  width: size.width,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: size.height * 0.4,
                    width: double.infinity,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            child: SizedBox(
                              height: size.height / 12,
                              width: size.width * 0.83,
                              child: TextField(
                                controller: _message,
                                decoration: InputDecoration(
                                  hintText: 'Send Message',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              String x = _message.text;
                              onSendMessage();
                              sendNotificationToUser('New Message', x);
                              // print(_message.text);
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser?.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: map['sendby'] == _auth.currentUser?.displayName
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue.shade500),
              child: Text(
                map['message'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade900),
              child: Text(
                map['message'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
// 199 usd = 1 lakh minutes

// 200 usd for year

// 109 usd for 2 lakh minutes
