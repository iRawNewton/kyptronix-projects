import 'package:client_onboarding_app/screens/dashboard/developer/email/functions/emailfunc.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/widget/app_dev_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphicsDev extends StatefulWidget {
  const GraphicsDev(
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
  State<GraphicsDev> createState() => _GraphicsDevState();
}

class _GraphicsDevState extends State<GraphicsDev> {
  TextEditingController taskCompleted = TextEditingController();
  TextEditingController challengesText = TextEditingController();
  TextEditingController opportunityText = TextEditingController();
  TextEditingController productivityText = TextEditingController();
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

              // task completed
              MyDevEmailWidget(
                controller: taskCompleted,
                hintText: 'Tasks Completed',
                infoText:
                    '\u2022 Created a visually appealing social media graphic for a new product launch, incorporating brand guidelines and messaging to ensure consistency across all platforms.\n\n'
                    '\u2022 Designed a series of banners for an upcoming trade show, incorporating eye-catching visuals and compelling copy to attract attention and drive booth traffic.\n\n'
                    '\u2022 Collaborated with the marketing team to create a set of infographics to communicate complex data in a visually appealing and easy-to-understand manner.\n\n'
                    '\u2022 Developed a new logo concept for a client, incorporating their feedback and preferences to create a unique and memorable design that reflects their brand identity.\n\n'
                    '\u2022 Edited and retouched product photos for an upcoming e-commerce campaign, ensuring high-quality visuals that are consistent with the brand\'s aesthetic',
              ),

              // Challenges faced
              MyDevEmailWidget(
                  controller: challengesText,
                  hintText: 'Challenges Faced',
                  infoText:
                      '\u2022 Limited turnaround time for a last-minute design request from the sales team, requiring me to prioritize tasks and manage my time efficiently to meet the deadline.\n\n'
                      '\u2022 Received feedback from multiple stakeholders with varying opinions on the same project, requiring careful communication and negotiation to achieve a final design that satisfied all parties.\n\n'
                      '\u2022 Dealing with technical issues with design software, requiring troubleshooting and finding alternative solutions to ensure uninterrupted workflow.'),

              // Opportunities for Improvement
              MyDevEmailWidget(
                  controller: opportunityText,
                  hintText: 'Opportunities for Improvement',
                  infoText:
                      '\u2022 Enhance time management skills to effectively prioritize and manage multiple design projects with tight deadlines.\n\n'
                      '\u2022 Improve communication skills to effectively handle feedback from various stakeholders and ensure alignment on design requirements.\n\n'
                      '\u2022 Stay updated with the latest design software updates and techniques to enhance efficiency and productivity.'),

              // Productivity
              MyDevEmailWidget(
                  controller: productivityText,
                  hintText: 'Productivity',
                  infoText: '\u2022 Login time\n\n'
                      '\u2022 Login date'),

              // links
              MyDevEmailWidget(
                  controller: linkText,
                  hintText: 'Link',
                  infoText: 'Provide link if any...'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // ********************************
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      // pref.setString("summaryText", summaryText.text);
                      pref.setString('taskCompleted', taskCompleted.text);
                      pref.setString('challenges', challengesText.text);
                      pref.setString('opportunity', opportunityText.text);
                      pref.setString('productivity', productivityText.text);
                      pref.setString('link', linkText.text);
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

                      taskCompleted.text = prefs.getString('taskCompleted')!;
                      challengesText.text = prefs.getString('challenges')!;
                      opportunityText.text = prefs.getString('opportunity')!;
                      productivityText.text = prefs.getString('productivity')!;
                      linkText.text = prefs.getString('link')!;
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
              // ********************************

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
                    if (taskCompleted.text != '' &&
                        challengesText.text != '' &&
                        opportunityText.text != '' &&
                        productivityText.text != '' &&
                        linkText.text != '' &&
                        sendTo.text != '' &&
                        ccTo.text != '') {
                      sendEmailGraphics(
                        context,
                        taskCompleted,
                        challengesText,
                        opportunityText,
                        productivityText,
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

                      String txt =
                          'Task Completed: \n${taskCompleted.text}\n \n'
                          'Challenges Faced: \n${challengesText.text}\n \n'
                          'Opportunities for Improvement: \n${opportunityText.text}\n \n'
                          'Productivity: \n${productivityText.text}\n \n'
                          'Link: \n${linkText.text}\n'; // fix controller

                      postData(
                          widget.devId, formattedDate, txt, widget.devName);

                      taskCompleted.clear();
                      challengesText.clear();
                      opportunityText.clear();
                      productivityText.clear();
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
