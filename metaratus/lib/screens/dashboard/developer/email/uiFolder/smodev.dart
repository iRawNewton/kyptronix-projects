import 'package:client_onboarding_app/screens/dashboard/developer/email/functions/emailfunc.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/widget/app_dev_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmoDev extends StatefulWidget {
  const SmoDev(
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
  State<SmoDev> createState() => _SmoDevState();
}

class _SmoDevState extends State<SmoDev> {
  TextEditingController summaryText = TextEditingController();
  TextEditingController smpText = TextEditingController();
  TextEditingController contentText = TextEditingController();
  TextEditingController campaignText = TextEditingController();
  TextEditingController smmText = TextEditingController();
  TextEditingController competitorText = TextEditingController();
  TextEditingController collaborationText = TextEditingController();
  TextEditingController recommendText = TextEditingController();
  TextEditingController challengesText = TextEditingController();
  TextEditingController nextDayText = TextEditingController();
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

              // Summary
              MyDevEmailWidget(
                  controller: summaryText,
                  hintText: 'Summary',
                  infoText:
                      'Provide a brief overview of the day\'s activities and accomplishments, highlighting any significant achievements or challenges encountered'),

              // Social Media Platforms
              MyDevEmailWidget(
                  controller: smpText,
                  hintText: 'Social Media Platforms',
                  infoText:
                      'List the social media platforms that were managed during the day, along with key metrics such as follower growth, engagement, and reach. Include any notable changes or trends observed on each platform.'),

              // Content Creation
              MyDevEmailWidget(
                  controller: contentText,
                  hintText: 'Content Creation',
                  infoText:
                      'Outline the content created or curated for social media, including the type of content (e.g., text, images, videos), platforms it was published on, and any associated metrics such as engagement or performance.'),

              // Campaigns and Promotions
              MyDevEmailWidget(
                  controller: campaignText,
                  hintText: 'Campaigns and Promotions',
                  infoText:
                      'Detail any ongoing or completed campaigns or promotions on social media, including the goals, strategies, and results. Highlight any successes or areas for improvement.'),

              // Social Media Monitoring
              MyDevEmailWidget(
                  controller: smmText,
                  hintText: 'Social Media Monitoring',
                  infoText:
                      'Provide an update on social media monitoring activities, including any mentions, comments, or messages received and how they were addressed. Include any relevant feedback or insights gathered from monitoring activities.'),

              // Competitor Analysis
              MyDevEmailWidget(
                  controller: competitorText,
                  hintText: 'Competitor Analysis',
                  infoText:
                      'Summarize any findings from competitor analysis on social media, such as their strategies, content, and engagement levels. Identify any opportunities or threats observed and possible strategies to capitalize on them'),

              // Collaborations and Partnerships
              MyDevEmailWidget(
                  controller: collaborationText,
                  hintText: 'Collaborations and Partnerships',
                  infoText:
                      'Report on any collaborations or partnerships initiated or maintained on social media, including any progress, results, or challenges faced.'),

              // Recommendations
              MyDevEmailWidget(
                  controller: recommendText,
                  hintText: 'Recommendations',
                  infoText:
                      'Offer any recommendations or suggestions for improvement in SMO strategies, content creation, campaigns, or monitoring based on the day\'s activities and insights gained.'),

              // Challenges and Solutions
              MyDevEmailWidget(
                  controller: challengesText,
                  hintText: 'Challenges and Solutions',
                  infoText:
                      'Highlight any challenges encountered during the day and provide solutions or strategies implemented to overcome them.'),

              // Next Day\'s Plan
              MyDevEmailWidget(
                  controller: nextDayText,
                  hintText: 'Next Day\'s Plan',
                  infoText:
                      'Outline the plan for the next day, including any upcoming campaigns, content creation, monitoring activities, or other relevant tasks.'),

              // links
              MyDevEmailWidget(
                  controller: linkText,
                  hintText: 'Link',
                  infoText: 'Provide link if any...'),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // **********************
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('summaryText', summaryText.text);
                      pref.setString('smpText', smpText.text);
                      pref.setString('contentText', contentText.text);
                      pref.setString('campaignText', campaignText.text);
                      pref.setString('smmText', smmText.text);
                      pref.setString('competitorText', competitorText.text);
                      pref.setString(
                          'collaborationText', collaborationText.text);
                      pref.setString('recommendText', recommendText.text);
                      pref.setString('challengesText', challengesText.text);
                      pref.setString('nextDayText', nextDayText.text);
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
                      smpText.text = prefs.getString('smpText') ?? '';
                      contentText.text = prefs.getString('contentText') ?? '';
                      campaignText.text = prefs.getString('campaignText') ?? '';
                      smmText.text = prefs.getString('smmText') ?? '';
                      competitorText.text =
                          prefs.getString('competitorText') ?? '';
                      collaborationText.text =
                          prefs.getString('collaborationText') ?? '';
                      recommendText.text =
                          prefs.getString('recommendText') ?? '';
                      challengesText.text =
                          prefs.getString('challengesText') ?? '';
                      nextDayText.text = prefs.getString('nextDayText') ?? '';
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

              // **********************
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
                    sendEmailSmo(
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
                      widget.devName,
                      sendTo,
                      ccTo,
                      widget.email,
                      widget.emailPass,
                    );

                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

                    String txt = 'Summary: \n${summaryText.text}\n \n'
                        'Social Media Platforms: \n${smpText.text}\n \n'
                        'Content Creation: \n${contentText.text}\n \n'
                        'Campaigns and Promotions: \n${campaignText.text}\n \n'
                        'Social Media Monitoring: \n${smmText.text}\n \n'
                        'Competitior Analysis: \n${competitorText.text}\n \n'
                        'Collaborations and Partnerships: \n${collaborationText.text}\n \n'
                        'Recommendations: \n${recommendText.text}\n \n'
                        'Challenges and Solutions: \n${challengesText.text}\n \n'
                        'Next Day\'s Plan: \n${nextDayText.text}\n \n'
                        'Links: \n${linkText.text}\n';

                    postData(widget.devId, formattedDate, txt, widget.devName);

                    summaryText.clear();
                    smpText.clear();
                    contentText.clear();
                    campaignText.clear();
                    smmText.clear();
                    competitorText.clear();
                    collaborationText.clear();
                    recommendText.clear();
                    challengesText.clear();
                    nextDayText.clear();
                    linkText.clear();

                    sendTo.clear();
                    ccTo.clear();
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
