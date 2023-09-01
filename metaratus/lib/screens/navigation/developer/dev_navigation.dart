import 'package:client_onboarding_app/screens/assignproject/developer/assignproject.dart';
import 'package:client_onboarding_app/screens/daily_task/developer/daily_task.dart';
import 'package:client_onboarding_app/screens/dashboard/developer/dev_dash.dart';

import 'package:flutter/material.dart';

import '../../dashboard/developer/email_screen.dart';

class MyDevNav extends StatefulWidget {
  const MyDevNav({super.key});

  @override
  State<MyDevNav> createState() => _MyDevNavState();
}

class _MyDevNavState extends State<MyDevNav> {
  // default index
  int index = 0;
  // screen lists
  final screens = [
    const MyDevDashboard(),
    const MyDevDailyTask(),
    const MyDevProjectDetails(),
    const MyDevEmailScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12),
          ),
        ),
        child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
                  this.index = index;
                }),
            height: 60.0,
            backgroundColor: Colors.white,
            // to hide labels
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(seconds: 3),
            destinations: const [
              // home
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              // daily task
              NavigationDestination(
                icon: Icon(Icons.task_outlined),
                selectedIcon: Icon(Icons.task_rounded),
                label: 'Daily Task',
              ),
              // task assigned
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: 'Task Assigned',
              ),
              // Email
              NavigationDestination(
                icon: Icon(Icons.email_outlined),
                selectedIcon: Icon(Icons.email),
                label: 'Email',
              ),
            ]),
      ),
    );
  }
}
