import 'package:client_onboarding_app/screens/dashboard/developer/email/functions/emailfunc.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/widget/app_dev_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmeDev extends StatefulWidget {
  const DmeDev(
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
  State<DmeDev> createState() => _DmeDevState();
}

class _DmeDevState extends State<DmeDev> {
  // controllers
  TextEditingController introduction = TextEditingController();
  TextEditingController keyMetrics = TextEditingController();
  TextEditingController websiteTraffic = TextEditingController();
  TextEditingController smp = TextEditingController();
  TextEditingController emailMarketing = TextEditingController();
  TextEditingController ppc = TextEditingController();
  TextEditingController seo = TextEditingController();
  TextEditingController contentMarketing = TextEditingController();
  TextEditingController goals = TextEditingController();
  TextEditingController conclusion = TextEditingController();
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
              Colors.blue.shade100,
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

              // Introduction
              MyDevEmailWidget(
                  controller: introduction,
                  hintText: 'Introduction',
                  infoText:
                      'Insert brief introduction about the purpose of the report, goals achieved, and any other relevant details.'),

              // Key Metrics
              MyDevEmailWidget(
                  controller: keyMetrics,
                  hintText: 'Key Metrics',
                  infoText:
                      'Insert a summary of the key metrics that were tracked and their progress towards the set goals.'),

              // Website traffic
              MyDevEmailWidget(
                  controller: websiteTraffic,
                  hintText: 'Website Traffic',
                  infoText:
                      'Insert a summary of website traffic for the day, including total visitors, page views, bounce rates, and time spent on the website.'),

              // Social Media Performance
              MyDevEmailWidget(
                  controller: smp,
                  hintText: 'Social Media Performance',
                  infoText:
                      'Insert a summary of social media performance for the day, including follower count, engagement rate, and any specific campaigns or posts that performed well.'),

              // Email Marketing
              MyDevEmailWidget(
                  controller: emailMarketing,
                  hintText: 'Email Marketing',
                  infoText:
                      'Insert a summary of email marketing performance for the day, including open rates, click-through rates, and any notable conversions or actions taken by subscribers.'),

              // PPC Advertising
              MyDevEmailWidget(
                  controller: ppc,
                  hintText: 'PPC Advertising',
                  infoText:
                      'Insert a summary of PPC advertising performance for the day, including ad spend, click-through rates, conversions, and any adjustments made to campaigns.'),

              // SEO
              MyDevEmailWidget(
                  controller: seo,
                  hintText: 'SEO',
                  infoText:
                      'Insert a summary of SEO performance for the day, including any updates made to the website, keyword rankings, and any changes in search engine traffic.'),

              // Content Marketing
              MyDevEmailWidget(
                  controller: contentMarketing,
                  hintText: 'Content Marketing',
                  infoText:
                      'Insert a summary of content marketing performance for the day, including any new content published, engagement rates, and any notable leads or conversions generated.'),

              // Goals for Tomorrow
              MyDevEmailWidget(
                  controller: goals,
                  hintText: 'Goals for Tomorrow',
                  infoText:
                      'Insert a summary of the goals and priorities for the next day, including any specific tasks or campaigns that need to be addressed.'),

              // Conclusion
              MyDevEmailWidget(
                  controller: conclusion,
                  hintText: 'Conclusion',
                  infoText:
                      'Insert a brief summary of the overall performance for the day, any challenges faced, and any plans for improvement in the future.'),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('introduction', introduction.text);
                      pref.setString('keyMetrics', keyMetrics.text);
                      pref.setString('websiteTraffic', websiteTraffic.text);
                      pref.setString('smp', smp.text);
                      pref.setString('emailMarketing', emailMarketing.text);
                      pref.setString('ppc', ppc.text);
                      pref.setString('seo', seo.text);
                      pref.setString('contentMarketing', contentMarketing.text);
                      pref.setString('goals', goals.text);
                      pref.setString('conclusion', conclusion.text);
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

                      introduction.text = prefs.getString('introduction') ?? '';
                      keyMetrics.text = prefs.getString('keyMetrics') ?? '';
                      websiteTraffic.text =
                          prefs.getString('websiteTraffic') ?? '';
                      smp.text = prefs.getString('smp') ?? '';
                      emailMarketing.text =
                          prefs.getString('emailMarketing') ?? '';
                      ppc.text = prefs.getString('ppc') ?? '';
                      seo.text = prefs.getString('seo') ?? '';
                      contentMarketing.text =
                          prefs.getString('contentMarketing') ?? '';
                      goals.text = prefs.getString('goals') ?? '';
                      conclusion.text = prefs.getString('conclusion') ?? '';
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

              // send to
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Send to'),
              ),

              MyDevEmailTextfield(controller: sendTo, hintText: ''),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade300),
                    ),
                    onPressed: () {
                      setState(() {
                        sendTo.text = 'sourav.kyptronix@gmail.com';
                      });
                    },
                    child: const Text(
                      'Sourav Sinha',
                      style: TextStyle(
                        fontFamily: 'fontThree',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              // cc to
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Cc'),
              ),
              MyDevEmailTextfield(controller: ccTo, hintText: ''),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade300),
                    ),
                    onPressed: () {
                      setState(() {
                        ccTo.text = 'kyptronix@gmail.com';
                      });
                    },
                    child: const Text(
                      'Kyptronix LLP',
                      style: TextStyle(
                        fontFamily: 'fontThree',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blue.shade400),
                  ),
                  onPressed: () {
                    if (sendTo.text != '' && ccTo.text != '') {
                      sendEmailDme(
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
                        widget.devName,
                        widget.email,
                        widget.emailPass,
                      );

                      DateTime now = DateTime.now();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(now);

                      String txt = 'Introduction: \n${introduction.text}\n \n'
                          'Key Metrics: \n${keyMetrics.text}\n \n'
                          'Website Traffic: \n${websiteTraffic.text}\n \n'
                          'Social Media Performance: \n${smp.text}\n \n'
                          'Email Marketing: \n${emailMarketing.text}\n \n'
                          'PPC Advertising: \n${ppc.text}\n \n'
                          'SEO: \n${seo.text}\n \n'
                          'Content Marketing: \n${contentMarketing.text}\n \n'
                          'Goals for Tomorrow: \n${goals.text}\n \n'
                          'Conclusion: \n${conclusion.text}\n \n'; // fix controller

                      postData(
                          widget.devId, formattedDate, txt, widget.devName);

                      introduction.clear();
                      keyMetrics.clear();
                      websiteTraffic.clear();
                      smp.clear();
                      emailMarketing.clear();
                      ppc.clear();
                      seo.clear();
                      contentMarketing.clear();
                      goals.clear();
                      conclusion.clear();
                      sendTo.clear();
                      ccTo.clear();
                      sendTo.clear();
                      ccTo.clear();
                    }
                  },
                  child: const Text(
                    'Send Email',
                    style: TextStyle(
                      fontFamily: 'fontThree',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
