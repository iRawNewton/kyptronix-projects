import 'dart:convert';

import 'package:client_onboarding_app/screens/dashboard/admin/projectmanagers/pmprofilewidget.dart';
import 'package:client_onboarding_app/screens/dashboard/admin/projectmanagers/popupwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyPmProfile extends StatefulWidget {
  const MyPmProfile({super.key, required this.id});
  final String id;

  @override
  State<MyPmProfile> createState() => _MyPmProfileState();
}

class _MyPmProfileState extends State<MyPmProfile> {
  dynamic data;
  dynamic dataFinance;
  bool isLoading = false;

  getProjectInfo() async {
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/projectmanagerprofile.php'),
        body: {
          'pm_id': widget.id,
        });
    if (response.statusCode == 200) {
      getFinance();
      if (response.body != 'Found Nothing') {
        setState(() {
          data = jsonDecode(response.body);
          // isLoading = true;
        });
      } else {
        setState(() {});
      }
    }
  }

  getFinance() async {
    DateTime now = DateTime.now();
    String currentMonth = now.month.toString();
    var response = await http.post(
        Uri.parse('$tempUrl/projectmanager/projectmanagerprofilefinance.php'),
        body: {
          'pm_id': widget.id,
          'month': currentMonth,
        });

    if (response.statusCode == 200) {
      if (response.body != 'Found Nothing') {
        setState(() {
          dataFinance = jsonDecode(response.body);
          isLoading = true;
        });
      } else {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    getProjectInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.width;
    var y = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manager Profile',
            style: TextStyle(
              fontFamily: 'FontOne',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade50,
        ),
        body: Container(
          width: x,
          height: y,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.person, color: Colors.blue, size: x / 4),
                        Text(
                          '${data[0]['pm_name']}',
                          style: TextStyle(
                            fontFamily: 'fontTwo',
                            fontWeight: FontWeight.bold,
                            fontSize: x * 0.07,
                          ),
                        ),
                        SelectableText(
                          '${data[0]['pm_email']}',
                          style: TextStyle(
                            fontFamily: 'fontTwo',
                            fontSize: x * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'Statistics',
                                style: TextStyle(
                                  fontFamily: 'fontTwo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Divider(
                                color: Colors.black87,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: x / 1.25,
                          child: GridView.count(
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ManagerProfileDialog(
                                          pmId: widget.id,
                                          type: 'pending',
                                        );
                                      });
                                },
                                child: PmProfileWidget(
                                  icon: Icons.access_time_outlined,
                                  number: '${data[0]['pending']}',
                                  text: 'Pending',
                                  color: Colors.grey,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ManagerProfileDialog(
                                          pmId: widget.id,
                                          type: 'ongoing',
                                        );
                                      });
                                },
                                child: PmProfileWidget(
                                  icon: Icons.refresh_outlined,
                                  number: '${data[0]['ongoing']}',
                                  text: 'Ongoing',
                                  color: Colors.orange,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ManagerProfileDialog(
                                          pmId: widget.id,
                                          type: 'complete',
                                        );
                                      });
                                },
                                child: PmProfileWidget(
                                  icon: Icons.check_circle_outline_outlined,
                                  number: '${data[0]['complete']}',
                                  text: 'Complete',
                                  color: Colors.green,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: PmProfileWidget(
                                  icon:
                                      Icons.playlist_add_check_circle_outlined,
                                  number: '${data[0]['total']}',
                                  text: 'Total',
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'Finances',
                                style: TextStyle(
                                  fontFamily: 'fontTwo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Divider(
                                color: Colors.black87,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: x / 2.5,
                          child: GridView.count(
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ManagerProfileDialogFinance(
                                          pmId: widget.id,
                                          type: 'month',
                                        );
                                      });
                                },
                                child: PmProfileWidget(
                                  icon: Icons.calendar_today_outlined,
                                  number:
                                      '\$${dataFinance[0]['current_month']}',
                                  text: 'Current Month',
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ManagerProfileDialogFinance(
                                          pmId: widget.id,
                                          type: 'total',
                                        );
                                      });
                                },
                                child: PmProfileWidget(
                                  icon: Icons.attach_money_outlined,
                                  number:
                                      '${dataFinance[0]['total_amount_paid']}',
                                  text: 'Total',
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                      height: 100,
                      child: LottieBuilder.asset(
                          'assets/animations/loading.json')),
                ),
        ));
  }
}
