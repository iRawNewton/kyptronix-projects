import 'package:client_onboarding_app/screens/dashboard/developer/email/functions/emailfunc.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/email/widget/app_dev_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailDev extends StatefulWidget {
  const EmailDev(
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
  State<EmailDev> createState() => _EmailDevState();
}

class _EmailDevState extends State<EmailDev> {
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
                      'List down the tasks that you have completed during the day.\n\nProvide a brief summary of each task and mention if it was a planned task or an ad-hoc task.\n\nInclude any major milestones or achievements related to the software development project.'),

              // Challenges Encountered
              MyDevEmailWidget(
                  controller: challengesText,
                  hintText: 'Challenges Encountered',
                  infoText:
                      'Highlight any challenges or obstacles you faced during the day.\n\nDescribe the issues you encountered and the steps you took to address them.\n\nIf there are any pending challenges that require further attention, mention them here as well.'),

              // Progress towards project goals
              MyDevEmailWidget(
                  controller: progressText,
                  hintText: 'Progress towards Project Goals',
                  infoText:
                      'Provide an update on the progress you made towards the overall goals of the app development project.\n\nInclude any key milestones achieved, deliverables completed, or any other significant progress made during the day'),

              // collaborations and communications
              MyDevEmailWidget(
                  controller: collaborationText,
                  hintText: 'Collaborations and Communications',
                  infoText:
                      'Detail any collaborations or communications you had with team members, stakeholders, or clients related to the app development project.\n\nInclude any meetings, discussions, or coordination efforts that took place during the day'),

              // next steps
              MyDevEmailWidget(
                  controller: nextStepText,
                  hintText: 'Next Steps',
                  infoText:
                      'Outline the next steps or tasks that you plan to work on in the upcoming days.\n\nProvide a brief description of each task and specify any dependencies or deadlines associated with them'),

              // opportunities for improvement
              MyDevEmailWidget(
                  controller: opportunityText,
                  hintText: 'Opportunities for Improvement',
                  infoText:
                      'Reflect on any areas where you think improvements can be made in terms of app development processes, tools, or workflow.\n\nOffer suggestions or recommendations on how to enhance productivity or quality in future tasks'),

              // Additional comments
              MyDevEmailWidget(
                  controller: additionalText,
                  hintText: 'Additional Comments',
                  infoText:
                      'Include any additional comments, updates, or information that you think would be relevant to share with your team or supervisor'),

              // links
              MyDevEmailWidget(
                  controller: linkText,
                  hintText: 'Link',
                  infoText: 'Provide link if any...'),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("summaryText", summaryText.text);
                      pref.setString("challengeText", challengesText.text);
                      pref.setString("progressText", progressText.text);
                      pref.setString("collabText", collaborationText.text);
                      pref.setString("nextStepText", nextStepText.text);
                      pref.setString("opportunityText", opportunityText.text);
                      pref.setString("additionalText", additionalText.text);
                      pref.setString("linkText", linkText.text);
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
                      summaryText.text = prefs.getString('summaryText')!;
                      challengesText.text = prefs.getString('challengeText')!;
                      progressText.text = prefs.getString('progressText')!;
                      collaborationText.text = prefs.getString('collabText')!;
                      nextStepText.text = prefs.getString('nextStepText')!;
                      opportunityText.text =
                          prefs.getString('opportunityText')!;
                      additionalText.text = prefs.getString('additionalText')!;
                      linkText.text = prefs.getString('linkText')!;
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

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                    if (sendTo.text != '' && ccTo.text != '') {
                      sendEmailDev(
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
                        widget.devName,
                        widget.email,
                        widget.emailPass,
                      );

                      DateTime now = DateTime.now();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(now);

                      String txt = 'Summary:\n${summaryText.text}\n \n'
                          'Challenges:\n${challengesText.text}\n \n'
                          'Progress:\n${progressText.text}\n \n'
                          'Collaborations:\n${collaborationText.text}\n \n'
                          'Next Step:\n${nextStepText.text}\n \n'
                          'Opportunity:\n${opportunityText.text}\n \n'
                          'Additional Info:\n${additionalText.text}\n \n'
                          'Link:\n${linkText.text}\n'; // fix controller

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
                      color: Colors.black87,
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
