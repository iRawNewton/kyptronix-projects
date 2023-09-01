import 'dart:convert';
import 'package:client_onboarding_app/calling/call_invitation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class ChatView extends StatefulWidget {
  const ChatView(
      {super.key,
      required this.chatRoomId,
      required this.userMap,
      required this.currentUsername,
      required this.senderUsername,
      required this.senderName});

  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final String currentUsername;
  final String senderUsername;
  final String senderName;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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

  @override
  void initState() {
    initInfo();

    getToken();

    super.initState();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher.png');
    var iOSInitialize = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    final localNotifications = FlutterLocalNotificationsPlugin();

    localNotifications.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
          } else {}
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              closeIconColor: Colors.white,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red,
              content: Text('$e'),
            ),
          );
        }
        return;
      },
    );
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        debugPrint('My token is $mtoken');
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection('UserTokens').doc('user1').set({
      'token': token,
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'KyptronixId',
        'Chat Notification',
        'Allow to get Chat Notification',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      final localNotifications = FlutterLocalNotificationsPlugin();
      await localNotifications.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAMu0ETE8:APA91bEtDlqcVEymk3uYdPj4nUBawWLAIy5O-XGxODFoeJKuHEbWZlyK5XaFTNAd-gJT-7SI7Su-OQ5DmiR1oJv0lkuvtu7EKONMgv6JUZlTWXrdbHhJSoMUGCFp41iqVeRbJPzgx1b7'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'KyptrnoixId'
              },
              'to': token,
            },
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          closeIconColor: Colors.white,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          content: Text('$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CallInvitationPage(
      username: widget.currentUsername,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 5,
            centerTitle: true,
            backgroundColor: Colors.lightBlue.shade100,
            title: Text(
              'You\'re viewing as ${widget.userMap['name']}',
              style: const TextStyle(
                fontFamily: 'fontOne',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 1.125,
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
                          return Container(
                            color: Colors.blue.shade100,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == widget.userMap['name']
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: map['sendby'] == widget.userMap['name']
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.indigo),
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
                  borderRadius: BorderRadius.circular(15), color: Colors.black),
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
