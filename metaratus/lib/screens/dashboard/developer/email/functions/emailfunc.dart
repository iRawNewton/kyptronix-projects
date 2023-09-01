import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;

import '../../../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

void showSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: Colors.white,
    content: const Text(
      'Email sent failed',
      style: TextStyle(
        fontFamily: 'fontTwo',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.red.shade400,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    width: MediaQuery.of(context).size.width * 0.8,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> sendEmailDev(
  context,
  summaryText,
  challengesText,
  progressText,
  collaborationText,
  nextStepText,
  opportunityText,
  additionalText,
  linkText,
  sendTo,
  ccTo,
  devName,
  email,
  emailPass,
) async {
  try {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMMM, yyyy').format(currentDate);
    var userEmail = '$email';
    var message = Message();
    message.subject = 'KRA Report - $formattedDate';
    // summary
    message.html = '<p><h3><b>KRA Date: $formattedDate</b></h3></p>'
        '<hr>'
        '<p><b>1. Summary of Tasks Accomplished:</b>'
        '<br>${summaryText.text}</p>'
        '<p><b>2. Challenges Encountered:</b>'
        '<br>${challengesText.text}</p>'
        '<p><b>3. Progress towards Project Goals:</b>'
        '<br>${progressText.text}</p>'
        '<p><b>4. Collaborations and Communications:</b>'
        '<br>${collaborationText.text}</p>'
        '<p><b>5. Next Steps:</b>'
        '<br>${nextStepText.text}</p>'
        '<p><b>6. Opportunities for Improvement:</b>'
        '<br>${opportunityText.text}</p>'
        '<p><b>7. Additional Comments:</b>'
        '<br>${additionalText.text}</p>'
        '<p><b>8. Links:</b>'
        '<br>${linkText.text}</p>'
        '<br><br>'
        '<p><b>Regards:</b></p>'
        '<p><b>$devName<b></p>'
        '<br>';

    message.from = Address(userEmail.toString(), '$devName');

    // receipents
    List<String> emails = sendTo.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccTo.text.split(',');
    List<Address> ccRecipient = [];
    for (String ccEmail in ccEmails) {
      recipients.add(Address(ccEmail.trim()));
    }
    message.ccRecipients = ccRecipient;

    var smtpServer = gmail(userEmail, '$emailPass');
    send(message, smtpServer).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          duration: const Duration(seconds: 10),
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

Future<void> sendEmailGraphics(
  context,
  taskCompleted,
  challengesText,
  opportunityText,
  productivityText,
  linkText,
  devName,
  sendTo,
  ccTo,
  email,
  emailPass,
) async {
  try {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMMM, yyyy').format(currentDate);
    var userEmail = '$email';
    var message = Message();
    message.subject = 'KRA Report - $formattedDate';
    // summary
    message.html = '<p><h3><b>KRA Date: $formattedDate</b></h3></p>'
        '<hr>'
        //
        '<p><b>1. Tasks Completed:</b>'
        '<br>${taskCompleted.text}</p>'
        //
        '<p><b>2. Challenges Faced:</b>'
        '<br>${challengesText.text}</p>'
        //
        '<p><b>3. Opportunities for Improvement:</b>'
        '<br>${opportunityText.text}</p>'
        //
        '<p><b>4. Productivity:</b>'
        '<br>${productivityText.text}</p>'
        //
        '<p><b>5. Links:</b>'
        '<br>${linkText.text}</p>'
        //
        '<br><br>'
        '<p><b>Regards:</b></p>'
        '<p><b>$devName<b></p>'
        '<br>';

    message.from = Address(userEmail.toString(), '$devName');

    // receipents
    List<String> emails = sendTo.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccTo.text.split(',');
    List<Address> ccRecipient = [];
    for (String ccEmail in ccEmails) {
      recipients.add(Address(ccEmail.trim()));
    }
    message.ccRecipients = ccRecipient;

    var smtpServer = gmail(userEmail, '$emailPass');
    send(message, smtpServer).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          duration: const Duration(seconds: 10),
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

Future<void> sendEmailSmo(
  context,
  summaryText,
  smpText,
  contentText,
  campaignText,
  smmText,
  competitorText,
  collaborationText,
  recommendText,
  challengesText,
  nextDayText,
  linkText,
  devName,
  sendTo,
  ccTo,
  email,
  emailPass,
) async {
  try {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMMM, yyyy').format(currentDate);
    var userEmail = '$email';
    var message = Message();
    message.subject = 'KRA Report - $formattedDate';
    // summary
    message.html = '<p><h3><b>KRA Date: $formattedDate</b></h3></p>'
        '<hr>'
        '<p><b>1. Summary: </b>'
        '<br>${summaryText.text}</p>'
        //
        '<p><b>2. Social Media Platforms:</b>'
        '<br>${smpText.text}</p>'
        //
        '<p><b>3. Content Creation: </b>'
        '<br>${contentText.text}</p>'
        //
        '<p><b>4. Campaigns and Promotions: </b>'
        '<br>${campaignText.text}</p>'
        //
        '<p><b>5. Social Media Monitoring: </b>'
        '<br>${smmText.text}</p>'
        //
        '<p><b>6. Competitor Analysis: </b>'
        '<br>${competitorText.text}</p>'
        //
        '<p><b>7. Collaborations and Partnerships: </b>'
        '<br>${collaborationText.text}</p>'
        //
        '<p><b>8. Recommendations: </b>'
        '<br>${recommendText.text}</p>'
        //
        '<p><b>9. Challenges and Solutions: </b>'
        '<br>${challengesText.text}</p>'
        //
        '<p><b>10. Next Day\'s Plan: </b>'
        '<br>${nextDayText.text}</p>'
        //
        '<p><b>11. Links: </b>'
        '<br>${linkText.text}</p>'
//
        '<br><br>'
        '<p><b>Regards:</b></p>'
        '<p><b>$devName<b></p>'
        '<br>';

    message.from = Address(userEmail.toString(), '$devName');

    // receipents
    List<String> emails = sendTo.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccTo.text.split(',');
    List<Address> ccRecipient = [];
    for (String ccEmail in ccEmails) {
      recipients.add(Address(ccEmail.trim()));
    }
    message.ccRecipients = ccRecipient;

    var smtpServer = gmail(userEmail, '$emailPass');
    send(message, smtpServer).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          duration: const Duration(seconds: 10),
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

Future<void> sendEmailSeo(
  context,
  summaryText,
  challengesText,
  progressText,
  collaborationText,
  nextStepText,
  opportunityText,
  additionalText,
  linkText,
  devName,
  sendTo,
  ccTo,
  email,
  emailPass,
) async {
  try {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMMM, yyyy').format(currentDate);
    var userEmail = '$email';
    var message = Message();
    message.subject = 'KRA Report - $formattedDate';
    // summary
    message.html = '<p><h2><b>KRA Date: $formattedDate</b></h2></p>'
        '<hr>'
        '<p><b>1. Overall Summary:</b>'
        '<br>${summaryText.text}</p>'
        '<p><b>2. Key Activities:</b>'
        '<br>${challengesText.text}</p>'
        '<p><b>3. Keyword Rankings:</b>'
        '<br>${progressText.text}</p>'
        '<p><b>4. Traffic Analysis:</b>'
        '<br>${collaborationText.text}</p>'
        '<p><b>5. Technical SEO:</b>'
        '<br>${nextStepText.text}</p>'
        '<p><b>6. Action Items:</b>'
        '<br>${additionalText.text}</p>'
        '<p><b>7. Next Steps:</b>'
        '<br>${collaborationText.text}</p>'
        '<p><b>8. Links:</b>'
        '<br>${linkText.text}</p>'
        '<br>'
        '<br>'
        '<p><b>Regards:</b></p>'
        '<p><b>$devName<b></p>'
        '<br>';

    message.from = Address(userEmail.toString(), '$devName');

    // receipents
    List<String> emails = sendTo.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccTo.text.split(',');
    List<Address> ccRecipient = [];
    for (String ccEmail in ccEmails) {
      recipients.add(Address(ccEmail.trim()));
    }
    message.ccRecipients = ccRecipient;

    var smtpServer = gmail(userEmail, '$emailPass');
    send(message, smtpServer).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          duration: const Duration(seconds: 10),
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

Future<void> sendEmailDme(
  context,
  introduction,
  keyMetrics,
  websiteTraffic,
  smp,
  emailMarketing,
  ppc,
  seo,
  contentMarketing,
  goals,
  conclusion,
  sendTo,
  ccTo,
  devName,
  email,
  emailPass,
) async {
  try {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMMM, yyyy').format(currentDate);
    var userEmail = '$email';
    // var userEmail = 'gourav.kyptronix@gmail.com';

    var message = Message();
    message.subject = 'KRA Report - $formattedDate';
    // summary
    message.html = '<p><h3><b>KRA Date: $formattedDate</b></h3></p>'
        '<hr>'
        '<p><b>1. Introduction:</b>'
        '<br>${introduction.text}</P>'
        '<p><b>2. Key Metrics:</b>'
        '<br>${keyMetrics.text}</p>'
        //
        '<p><b>3. Website Traffic:</b>'
        '<br>${websiteTraffic.text}</p>'
        //
        '<p><b>4. Social Media Performance:</b>'
        '<br>${smp.text}</p>'
        //
        '<p><b>5. Email Marketing:</b>'
        '<br>${emailMarketing.text}</p>'
        //
        '<p><b>6. PPC Advertising:</b>'
        '<br>${ppc.text}</p>'
        //
        '<p><b>7. SEO:</b>'
        '<br>${seo.text}</p>'
        //
        '<p><b>8. Content Marketing:</b>'
        '<br>${contentMarketing.text}</p>'
        //
        '<p><b>9. Goals for Tomorrow:</b>'
        '<br>${goals.text}</p>'
        //
        '<p><b>10. Conclusion:</b>'
        '<br>${conclusion.text}</p>'
        //
        '<br>'
        '<br>'
        '<p><b>Regards:</b></p>'
        '<p><b>$devName<b></p>'
        '<br>';

    message.from = Address(userEmail.toString(), '$devName');

    // receipents
    List<String> emails = sendTo.text.split(',');
    List<Address> recipients = [];
    for (String email in emails) {
      recipients.add(Address(email.trim()));
    }
    message.recipients = recipients;

    // cc receipents
    List<String> ccEmails = ccTo.text.split(',');
    List<Address> ccRecipient = [];
    for (String ccEmail in ccEmails) {
      recipients.add(Address(ccEmail.trim()));
    }
    message.ccRecipients = ccRecipient;

    var smtpServer = gmail(userEmail, '$emailPass');
    // var smtpServer = gmail(userEmail, 'lativosxdxzbykhm');

    send(message, smtpServer).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          duration: const Duration(seconds: 10),
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

// class RemoteService {
//   Future postData(devId, sentDate, sentTxt, nameTxt) async {
//     DateTime now = DateTime.now();
//     String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

//     // Send the POST request
//     var response =
//         await http.post(Uri.parse('$tempUrl/dev/storeDailyEmail.php'), body: {
//       'sentId': devId,
//       'sentdate': '$sentDate',
//       'senttxt': '$sentTxt',
//       'name': '$nameTxt',
//     });

//     if (response.statusCode == 200) {
//       return 'saved';
//     } else {
//       return 'Error occurred';
//     }
//   }
// }

postData(devId, sentDate, sentTxt, nameTxt) async {
  // main details
  var response =
      await http.post(Uri.parse('$tempUrl/dev/storeDailyEmail.php'), body: {
    'sentId': devId,
    'sentdate': '$sentDate',
    'senttxt': '$sentTxt',
    'name': '$nameTxt',
  });

  if (response.statusCode == 200) {
  } else {}
}
