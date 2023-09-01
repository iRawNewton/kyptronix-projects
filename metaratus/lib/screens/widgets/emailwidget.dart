import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> projectRelatedEmail(context, toText, subject, body) async {
  // try {
  var userEmail = 'kyptronix@gmail.com';
  var message = Message();
  message.subject = subject;
  // summary
  message.html = body;

  message.from = Address(userEmail.toString(), 'Souvik Karmakar');

  // receipents
  List<String> emails = toText.split(',');
  List<Address> recipients = [];
  for (String email in emails) {
    recipients.add(Address(email.trim()));
  }
  message.recipients = recipients;

  // cc receipents

  var smtpServer = gmail(userEmail, 'cnasttaokkyfzsug');
  send(message, smtpServer);
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
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         e.toString(),
  //         style: const TextStyle(
  //           fontFamily: 'fontTwo',
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //       backgroundColor: Colors.red,
  //       elevation: 8,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       behavior: SnackBarBehavior.floating,
  //       width: MediaQuery.of(context).size.width * 0.8,
  //     ),
  //   );
  // }
}
