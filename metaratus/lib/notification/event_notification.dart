import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> sendCustomNotificationToUser(
    context, String title, String content, String id) async {
  // create a notification with the given player ID as the target
  var notification = OSCreateNotification(
    playerIds: [id],
    content: content, // content
    heading: title, // title
    androidSound: 'iphone_sound',
    androidChannelId: '45c816db-aff6-47e9-8dbd-467bcca4bc99',
    additionalData: {'category': 'KyptronixDemo'},
  );
  await OneSignal.shared.postNotification(notification);
}
