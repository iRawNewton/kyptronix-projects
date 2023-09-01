import 'package:client_onboarding_app/screens/dashboard/client/client_dash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chat/methods/methods.dart';
import '../2selectuser/homescreen.dart';

class MyClientDrawyer extends StatefulWidget {
  const MyClientDrawyer({super.key});

  @override
  State<MyClientDrawyer> createState() => _MyClientDrawyerState();
}

class _MyClientDrawyerState extends State<MyClientDrawyer> {
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
              accountEmail: Text('Client Account',
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
                  builder: (context) => const MyClientDashboard(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.share_rounded),
          //   title: const Text('Refer a friend',
          //       style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () async {
          //     String text =
          //         'Hey!\nI just wanted to let you know about an amazing digital marketing agency called Kyptronix LLP. They provide top-notch services like website development, website design, graphics design, and digital marketing.\n\nWhat sets them apart is their team of highly skilled professionals who have extensive knowledge and real-time experience in all aspects of digital marketing. They cater to clients from all around the world and have a great track record of delivering excellent results.\n\nI highly recommend Kyptronix LLP for any digital marketing needs you may have. And if you sign up using my name as referral and you\'ll get 10% discount on all the services. \n\nHere\'s the link to their website: https://kyptronix.us/  \nClick https://calendly.com/kyptronix for free consultancy!';
          //     final box = context.findRenderObject() as RenderBox?;
          //     await Share.share(text,
          //         subject:
          //             'Referral for an Amazing Digital Marketing Agency - Kyptronix LLP',
          //         sharePositionOrigin:
          //             box!.localToGlobal(Offset.zero) & box.size);
          //     // var x = Image.asset('assets/images/bg.png');
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.work_rounded),
          //   title: const Text('Portfolio',
          //       style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () {
          //     Future<void> launchBrowser(Uri url) async {
          //       if (!await launchUrl(
          //         url,
          //         mode: LaunchMode.inAppWebView,
          //         webViewConfiguration:
          //             const WebViewConfiguration(enableDomStorage: true),
          //       )) {
          //         throw Exception('could not launch $url');
          //       }
          //     }

          //     launchBrowser(Uri.parse('https://kyptronix.us/portfolio.html'));
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.info_rounded),
          //   title:
          //       const Text('About Us', style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () {
          //     Future<void> launchBrowser(Uri url) async {
          //       if (!await launchUrl(
          //         url,
          //         mode: LaunchMode.inAppWebView,
          //         webViewConfiguration:
          //             const WebViewConfiguration(enableDomStorage: true),
          //       )) {
          //         throw Exception('could not launch $url');
          //       }
          //     }

          //     launchBrowser(Uri.parse('https://kyptronix.us/about-us.html'));
          //   },
          // ),

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
          const Spacer(),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 60, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 45, child: Divider(color: Colors.black)),
                Text(
                  'Let\'s connect',
                  style: TextStyle(
                    fontFamily: 'foneTwo',
                  ),
                ),
                SizedBox(width: 45, child: Divider(color: Colors.black)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 60, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.055,
                  child: IconButton(
                    onPressed: () {
                      void launchFb() async {
                        final Uri facebook =
                            Uri.parse('https://www.facebook.com/Kyptronix/');
                        launchUrl(facebook,
                            mode: LaunchMode.externalApplication);
                      }

                      launchFb();
                    },
                    icon: Image.asset('assets/icons/fb.ico'),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.055,
                  child: IconButton(
                    onPressed: () {
                      void launchTwitter() async {
                        final Uri facebook =
                            Uri.parse('https://twitter.com/Kyptronixus');
                        launchUrl(facebook,
                            mode: LaunchMode.externalApplication);
                      }

                      launchTwitter();
                    },
                    icon: Image.asset('assets/icons/twitter.ico'),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.055,
                  child: IconButton(
                    onPressed: () {
                      void launchLinkedIn() async {
                        final Uri facebook = Uri.parse(
                            'https://www.linkedin.com/company/kyptronixllp');

                        launchUrl(facebook,
                            mode: LaunchMode.externalApplication);
                      }

                      launchLinkedIn();
                    },
                    icon: Image.asset('assets/icons/linkedin.ico'),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.055,
                  child: IconButton(
                    onPressed: () {
                      void launchInstagram() async {
                        final Uri facebook = Uri.parse(
                            'https://www.instagram.com/kyptronix_llp/');
                        launchUrl(facebook,
                            mode: LaunchMode.externalApplication);
                      }

                      launchInstagram();
                    },
                    icon: Image.asset('assets/icons/ig.ico'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
      ),
    );
  }
}
