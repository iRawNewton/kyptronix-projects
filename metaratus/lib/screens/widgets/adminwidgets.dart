import 'package:client_onboarding_app/chat/admin/findchat.dart';
import 'package:client_onboarding_app/screens/daily_task/admin/dev_list.dart';
import 'package:client_onboarding_app/screens/dashboard/admin/admindash.dart';
import 'package:client_onboarding_app/screens/dashboard/admin/adminmail.dart';
import 'package:client_onboarding_app/screens/dashboard/admin/projectmanagers/pmfile.dart';
import 'package:client_onboarding_app/screens/list/projectlist.dart';

import 'package:flutter/material.dart';

// import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;

import '../../chat/methods/methods.dart';
import '../2selectuser/homescreen.dart';

class MyAdminDrawyer extends StatefulWidget {
  const MyAdminDrawyer({super.key});

  @override
  State<MyAdminDrawyer> createState() => _MyAdminDrawyerState();
}

class _MyAdminDrawyerState extends State<MyAdminDrawyer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: const EdgeInsets.all(8.0),
        children: [
          const DrawerHeader(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 1, 55, 99),
              ),
              accountName: Text(
                'Metaratus',
                style: TextStyle(fontFamily: 'fontOne'),
              ),
              accountEmail: Text('Super Admin Panel',
                  style: TextStyle(fontFamily: 'fontTwo')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:
                const Text(' Home ', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyAdminDash(),
                ),
              );
            },
          ),
          // MyNewPm

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Project Manager ',
                style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyPmList()));
            },
          ),

          // projects
          ListTile(
            leading: const Icon(Icons.dashboard),
            title:
                const Text('Projects', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProjectList(),
                ),
              );
            },
          ),

          // sales
          // ListTile(
          //   leading: const Icon(Icons.shopping_bag_rounded),
          //   title: const Text('New Sales',
          //       style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const MySales(),
          //       ),
          //     );
          //   },
          // ),

          // daily tasks
          ListTile(
            leading: const Icon(Icons.task_alt_rounded),
            title: const Text('Daily Tasks ',
                style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DailyTaskDevList(),
                ),
              );
            },
          ),

          // chats
          ListTile(
            leading: const Icon(Icons.chat_bubble),
            title: const Text('Chats', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyAdminChatFind(),
                ),
              );
            },
          ),
          // Questionaire
          // ListTile(
          //   leading: const Icon(Icons.question_answer),
          //   title: const Text('Questionaires',
          //       style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const AdminQuestionPage(),
          //       ),
          //     );
          //   },
          // ),
          // mail
          ListTile(
            leading: const Icon(Icons.mail_rounded),
            title:
                const Text('E-mail', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyAdminEmail(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title:
                const Text('Logout', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () async {
              logOut(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const MyUsers();
                  },
                ),
              );
              // deleteSharedPrefs();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("cliId", '');
              prefs.setString("cliname", '');
            },
          ),
          // const Spacer(),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15, 0, 60, 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: const [
          //       SizedBox(width: 45, child: Divider(color: Colors.black)),
          //       Text(
          //         'Let\'s connect',
          //         style: TextStyle(
          //           fontFamily: 'foneTwo',
          //         ),
          //       ),
          //       SizedBox(width: 45, child: Divider(color: Colors.black)),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15, 0, 60, 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.055,
          //         child: IconButton(
          //           onPressed: () {
          //             void launchFb() async {
          //               final Uri facebook =
          //                   Uri.parse('https://www.facebook.com/Kyptronix/');
          //               launchUrl(facebook,
          //                   mode: LaunchMode.externalApplication);
          //             }

          //             launchFb();
          //           },
          //           icon: Image.asset('assets/icons/fb.ico'),
          //         ),
          //       ),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.055,
          //         child: IconButton(
          //           onPressed: () {
          //             void launchTwitter() async {
          //               final Uri facebook =
          //                   Uri.parse('https://twitter.com/Kyptronixus');
          //               launchUrl(facebook,
          //                   mode: LaunchMode.externalApplication);
          //             }

          //             launchTwitter();
          //           },
          //           icon: Image.asset('assets/icons/twitter.ico'),
          //         ),
          //       ),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.055,
          //         child: IconButton(
          //           onPressed: () {
          //             void launchLinkedIn() async {
          //               final Uri facebook = Uri.parse(
          //                   'https://www.linkedin.com/company/kyptronixllp');

          //               launchUrl(facebook,
          //                   mode: LaunchMode.externalApplication);
          //             }

          //             launchLinkedIn();
          //           },
          //           icon: Image.asset('assets/icons/linkedin.ico'),
          //         ),
          //       ),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.055,
          //         child: IconButton(
          //           onPressed: () {
          //             void launchInstagram() async {
          //               final Uri facebook = Uri.parse(
          //                   'https://www.instagram.com/kyptronix_llp/');
          //               launchUrl(facebook,
          //                   mode: LaunchMode.externalApplication);
          //             }

          //             launchInstagram();
          //           },
          //           icon: Image.asset('assets/icons/ig.ico'),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}
