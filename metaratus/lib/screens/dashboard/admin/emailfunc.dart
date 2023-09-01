import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmailAdmin(
    context, toText, ccText, bccText, subject, body) async {
  try {
    var userEmail = 'kyptronix@gmail.com';
    var message = Message();
    message.subject = subject.text;
    // summary
    message.html = body.text;

    message.from = Address(userEmail.toString(), 'Souvik Karmakar');

    // receipents
    List<String> emails = toText.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccText.text.split(',');
    List<Address> ccRecipient = [];
    if (ccEmails.isNotEmpty) {
      for (String ccEmail in ccEmails) {
        recipients.add(Address(ccEmail.trim()));
      }
      message.ccRecipients = ccRecipient;
    }

    // bcc receipents
    List<String> bccEmails = bccText.text.split(',');
    List<Address> bccRecipient = [];
    if (bccEmails.isNotEmpty) {
      for (String bccEmail in bccEmails) {
        recipients.add(Address(bccEmail.trim()));
      }
      message.bccRecipients = bccRecipient;
    }

    var smtpServer = gmail(userEmail, 'cnasttaokkyfzsug');
    send(message, smtpServer).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
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
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(
            fontFamily: 'fontTwo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}
