import 'package:client_onboarding_app/screens/dashboard/admin/adminmail.dart';
import 'package:client_onboarding_app/screens/list/clientlist.dart';
import 'package:client_onboarding_app/screens/list/developerlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../chat/methods/methods.dart';
import '../2selectuser/homescreen.dart';
import '../dashboard/pm/payments/paymenthistory.dart';
import '../dashboard/pm/pm_dashboard.dart';
import '../list/managerprojectlist.dart';

class MyDrawerInfo extends StatefulWidget {
  const MyDrawerInfo({super.key});

  @override
  State<MyDrawerInfo> createState() => _MyDrawerInfoState();
}

class _MyDrawerInfoState extends State<MyDrawerInfo> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: const EdgeInsets.all(8.0),
        children: [
          DrawerHeader(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.red.shade100),
              accountName: const Text(
                'Metaratus',
                style: TextStyle(
                    fontFamily: 'fontOne',
                    color: Colors.black87,
                    fontSize: 18.0),
              ),
              accountEmail: const Text(
                'Manager Account',
                style: TextStyle(
                    fontFamily: 'fontTwo',
                    color: Colors.black87,
                    fontSize: 14.0),
              ),
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
                  builder: (context) => const MyPmDashboard(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title:
                const Text('Clients', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyClientList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.developer_mode),
            title: const Text('Development Team',
                style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyDevList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title:
                const Text('Projects', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // MyPmProjectList
                  //
                  builder: (context) => const MyPmProjectList(),
                ),
              );
            },
          ),
          // sales
          // ListTile(
          //   leading: const Icon(Icons.shopping_bag_rounded),
          //   title: const Text('New Project Request',
          //       style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const NewProjectRequest(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.payment_rounded),
            title:
                const Text('Payments', style: TextStyle(fontFamily: 'fontTwo')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // MyPmProjectList
                  //
                  builder: (context) => const ViewDailyPayment(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.mail_outline_rounded),
          //   title:
          //       const Text('E-mail', style: TextStyle(fontFamily: 'fontTwo')),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const MyAdminEmail(),
          //       ),
          //     );
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
              prefs.setString("pmId", '');
              prefs.setString("pmname", '');
            },
          ),
        ],
      ),
    );
  }
}
