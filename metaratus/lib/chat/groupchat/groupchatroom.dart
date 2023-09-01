import 'dart:convert';
// import 'package:client_onboarding_app/calling/call_invitation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import '../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class GroupChatRoom extends StatefulWidget {
  const GroupChatRoom({
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
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = false;

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
  List<String> myDeviceId = [];
  List<String> deviceIds = [];
  final TextEditingController deviceIdController = TextEditingController();
  getDeviceId() async {
    var response = await http
        .post(Uri.parse('$tempUrl/groupchat/notification.php'), body: {});

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      setState(() {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        for (var item in jsonResponse) {
          String deviceId = item['device_id'];
          deviceIds.add(deviceId);
        }
      });
    } else {}
  }

  Future<void> sendNotificationToUser(String title, String content) async {
    // create a notification with the given player ID as the target
    var notification = OSCreateNotification(
      playerIds: deviceIds,
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
    // removed: safearea wrapped with CallInvitationPage where username = widget.currentUsername,
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Colors.lightBlue.shade100,
          centerTitle: true,
          title: const Text(
            'Development Team',
            style: TextStyle(
                fontFamily: 'fontOne',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        body: Container(
          height: double.infinity,
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
              crossAxisAlignment: CrossAxisAlignment.center,
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

                // send text part
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: TextField(
                              controller: _message,
                              decoration: const InputDecoration(
                                  hintText: 'Send Message',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            getDeviceId();
                            String x = _message.text;
                            onSendMessage();
                            sendNotificationToUser('New Message', x);
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ]),
                ),
                // const SizedBox(height: 55.0),
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
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(0),
                  ),
                  color: Colors.blue.shade800),
              child: Text(
                map['message'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          : InkWell(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromARGB(255, 226, 226, 226)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      map['sendby'].toString(),
                      style: TextStyle(
                        fontFamily: 'fontTwo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    Text(
                      map['message'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Visibility(
                      visible: isVisible,
                      child: Text(
                        DateFormat('dd MMM, yyyy HH:mm')
                            .format(map['time'].toDate()),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
