import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmailToNewEmployee(
  context,
  toText,
  ccText,
  name,
) async {
  try {
    var userEmail = 'kyptronix@gmail.com';
    var message = Message();

    // message.subject = subject.text;
    message.subject = 'Welcome to Kyptronix LLP';
    // summary
    message.html = ' <p><b>Dear ${name.text},</b></p>'
        '<p>As we strive to maintain efficiency and transparency in our workflow, I\'d like to remind everyone to update your daily tasks on the Kyptronix LLP mobile application using the login credentials and download link provided here:</p>'
        '<p>Link: <a href="https://play.google.com/store/apps/details?id=com.kyptronix.dev">Kyptronix Care</a></p>'
        '<p>User name: ${toText.text}</p>'
        '<p>Password: Kyptronix2023</p>'
        ' <p>This will help us keep track of the progress on each project and ensure that all assigned tasks are duly accounted for.</p>'
        ' <p>Whether you\'re working remotely or at the office, please make it a habit to log in to the application and update your tasks regularly. By doing so, we can collaborate more effectively, identify potential bottlenecks, and address any challenges that may arise promptly.</p>'
        ' <p>If you encounter any technical difficulties or have questions about using the mobile application, feel free to reach out to our support team for assistance. They are available to help you navigate through the system and ensure a smooth experience.</p>'
        ' <p>Let\'s make the most of this tool to enhance our productivity and deliver exceptional results. Thank you for your cooperation, and have a productive day!</p>'
        '<br>'
        ' <br>'
        '<p>Best regards,</p>'
        '<p>Support Team</p>'
        '<p>Kyptronix LLP</p>';

    // message.html = body.text;

    message.from = Address(userEmail.toString(), 'Kyptronix LLP');

    // receipents
    List<String> emails = toText.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccText.split(',');
    List<Address> ccRecipient = [];
    for (String ccEmail in ccEmails) {
      recipients.add(Address(ccEmail.trim()));
    }
    message.ccRecipients = ccRecipient;

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
