import 'package:client_onboarding_app/screens/dashboard/developer/email/functions/emailfunc.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/widget/app_dev_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeoDev extends StatefulWidget {
  const SeoDev(
      {super.key,
      required this.devId,
      required this.devName,
      required this.email,
      required this.emailPass});

  final String devId;
  final String devName;
  final String email;
  final String emailPass;

  @override
  State<SeoDev> createState() => _SeoDevState();
}

class _SeoDevState extends State<SeoDev> {
  TextEditingController summaryText = TextEditingController();
  TextEditingController challengesText = TextEditingController();
  TextEditingController progressText = TextEditingController();
  TextEditingController collaborationText = TextEditingController();

  TextEditingController nextStepText = TextEditingController();
  TextEditingController opportunityText = TextEditingController();
  TextEditingController additionalText = TextEditingController();

  TextEditingController linkText = TextEditingController();
  TextEditingController sendTo = TextEditingController();
  TextEditingController ccTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade100,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Summary of task accomplished
              MyDevEmailWidget(
                  controller: summaryText,
                  hintText: 'Summary',
                  infoText:
                      'Insert a brief summary of the day\'s activities and overall progress made towards SEO goals.'),

              // Challenges Encountered
              MyDevEmailWidget(
                  controller: challengesText,
                  hintText: 'Key Activites',
                  infoText:
                      '\u2022 Conducted keyword research and identified potential new keywords for the website\n\n'
                      '\u2022 Updated on-page optimization for top landing pages\n\n'
                      '\u2022 Submitted a sitemap to Google Search Console for indexing\n\n'
                      '\u2022 Conducted a backlink audit and identified several low-quality backlinks to disavow'),

              // Progress towards project goals
              MyDevEmailWidget(
                  controller: progressText,
                  hintText: 'Keyword Rankings',
                  infoText:
                      'Insert a list of the current keyword rankings for the website, highlighting any significant changes or improvements.'),

              // collaborations and communications
              MyDevEmailWidget(
                  controller: collaborationText,
                  hintText: 'Traffic Analysis',
                  infoText:
                      'Insert a summary of the website\'s traffic for the day, including the number of visitors, pageviews, and any notable changes from the previous day or week.'),

              // next steps
              MyDevEmailWidget(
                  controller: nextStepText,
                  hintText: 'Technical SEO',
                  infoText:
                      'Insert any technical issues encountered during the day, along with the steps taken to resolve them.'),

              // opportunities for improvement
              MyDevEmailWidget(
                  controller: opportunityText,
                  hintText: 'Action Items',
                  infoText:
                      'Insert a list of any action items that need to be addressed in the coming days or weeks, along with deadlines and responsible parties.'),

              // Additional comments
              MyDevEmailWidget(
                  controller: additionalText,
                  hintText: 'Next Steps',
                  infoText:
                      'Insert a brief summary of the next steps for the SEO campaign, including upcoming tasks, goals, and targets.'),

              // links
              MyDevEmailWidget(
                  controller: linkText,
                  hintText: 'Link',
                  infoText: 'Provide link if any...'),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('summaryText', summaryText.text);
                      pref.setString('challengesText', challengesText.text);
                      pref.setString('progressText', progressText.text);
                      pref.setString(
                          'collaborationText', collaborationText.text);
                      pref.setString('nextStepText', nextStepText.text);
                      pref.setString('opportunityText', opportunityText.text);
                      pref.setString('additionalText', additionalText.text);
                      pref.setString('linkText', linkText.text);
                    },
                    icon: const Icon(
                      Icons.save_rounded,
                      color: Colors.indigo,
                    ),
                    label: const Text(
                      'Save Email',
                      style: TextStyle(
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      summaryText.text = prefs.getString('summaryText') ?? '';
                      challengesText.text =
                          prefs.getString('challengesText') ?? '';
                      progressText.text = prefs.getString('progressText') ?? '';
                      collaborationText.text =
                          prefs.getString('collaborationText') ?? '';
                      nextStepText.text = prefs.getString('nextStepText') ?? '';
                      opportunityText.text =
                          prefs.getString('opportunityText') ?? '';
                      additionalText.text =
                          prefs.getString('additionalText') ?? '';
                      linkText.text = prefs.getString('linkText') ?? '';
                    },
                    icon: const Icon(
                      Icons.restore,
                      color: Colors.indigo,
                    ),
                    label: const Text(
                      'Restore Email',
                      style: TextStyle(
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Send to'),
              ),
              MyDevEmailTextfield(controller: sendTo, hintText: 'Enter email'),
              // Row(
              //   children: [
              //     ElevatedButton(
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStatePropertyAll(Colors.blue.shade50),
              //       ),
              //       onPressed: () {
              //         setState(() {
              //           sendTo.text = 'sourav.kyptronix@gmail.com';
              //         });
              //       },
              //       child: const Text(
              //         'Sourav Sinha',
              //         style: TextStyle(
              //           fontFamily: 'fontThree',
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black87,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Cc'),
              ),

              MyDevEmailTextfield(controller: ccTo, hintText: 'Enter email'),
              // Row(
              //   children: [
              //     ElevatedButton(
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStatePropertyAll(Colors.blue.shade50),
              //       ),
              //       onPressed: () {
              //         setState(() {
              //           ccTo.text = 'kyptronix@gmail.com';
              //         });
              //       },
              //       child: const Text(
              //         'Kyptronix LLP',
              //         style: TextStyle(
              //           fontFamily: 'fontThree',
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black87,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.amber.shade800),
                  ),
                  onPressed: () {
                    if (summaryText.text != "" &&
                        challengesText.text != "" &&
                        progressText.text != "" &&
                        collaborationText.text != "" &&
                        nextStepText.text != "" &&
                        opportunityText.text != "" &&
                        additionalText.text != "" &&
                        linkText.text != "" &&
                        sendTo.text != "" &&
                        ccTo.text != "") {
                      sendEmailSeo(
                        context,
                        summaryText,
                        challengesText,
                        progressText,
                        collaborationText,
                        nextStepText,
                        opportunityText,
                        additionalText,
                        linkText,
                        widget.devName,
                        sendTo,
                        ccTo,
                        widget.email,
                        widget.emailPass,
                      );
                      DateTime now = DateTime.now();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(now);

                      String txt = 'Overall Summary: \n${summaryText.text}\n \n'
                          'Key Activities: \n${challengesText.text}\n \n'
                          'Keywords Rankings: \n${progressText.text}\n \n'
                          'Traffic Analysis: \n${collaborationText.text}\n \n'
                          'Traffic SEO: \n${nextStepText.text}\n \n'
                          'Action Items: \n${opportunityText.text}\n \n'
                          'Next Steps: \n${additionalText.text}\n \n'
                          'Links: \n${linkText.text}\n';

                      postData(
                          widget.devId, formattedDate, txt, widget.devName);

                      summaryText.clear();
                      challengesText.clear();
                      progressText.clear();
                      collaborationText.clear();
                      nextStepText.clear();
                      opportunityText.clear();
                      additionalText.clear();
                      linkText.clear();
                      sendTo.clear();
                      ccTo.clear();
                    }
                  },
                  child: const Text(
                    'Send Email',
                    style: TextStyle(
                      fontFamily: 'fontThree',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
