import 'dart:convert';

import 'package:client_onboarding_app/screens/daily_task/admin/view_daily_task.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class DailyTaskDevList extends StatefulWidget {
  const DailyTaskDevList({super.key});

  @override
  State<DailyTaskDevList> createState() => _DailyTaskDevListState();
}

class _DailyTaskDevListState extends State<DailyTaskDevList> {
  bool dataAvailable = false;
  bool notLoading = false;
  dynamic data;

  Future<void> getDevList() async {
    var response = await http.post(
      Uri.parse('$tempUrl/admin/DevList/devList.php'),
    );

    if (response.statusCode == 200) {
      setState(() {
        notLoading = true;
      });
      setState(() {
        data = jsonDecode(response.body);
        dataAvailable = true;
      });
    } else {
      setState(() {
        dataAvailable = false;
      });
    }
  }

  @override
  void initState() {
    getDevList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Daily Task',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: notLoading
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dataAvailable
                      ? FutureBuilder(
                          future: getDevList(),
                          builder: (context, snapshot) {
                            if (data.length == 0) {
                              return SizedBox(
                                child: Column(
                                  children: [
                                    LottieBuilder.asset(
                                        'assets/animations/nodata_available.json'),
                                    const SizedBox(height: 40.0),
                                  ],
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        // setState(() {
                                        //   isLoading = true;
                                        //   senderEmail =
                                        //       data[index]['cli_email'].toString();
                                        //   // for calling
                                        //   currentUsername = 'usermanager';
                                        //   cliName = data[index]['cli_name'].toString();
                                        //   cliUsername =
                                        //       data[index]['cli_userid'].toString();
                                        // });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewDailyTaskAdmin(
                                              devId:
                                                  data[index]['id'].toString(),
                                            ),
                                          ),
                                        );

                                        // onSearch(senderEmail);
                                      },
                                      child: ListTile(
                                        leading: const Icon(Icons.person),
                                        iconColor: Colors.black,
                                        tileColor: Colors.amber,
                                        title: Text(
                                          data[index]['cli_name'].toString(),
                                        ),
                                        subtitle: Text(data[index]['cli_phone']
                                            .toString()),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(color: Colors.grey),
                                ),
                              );
                            }
                          },
                        )
                      : Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: LottieBuilder.asset(
                                'assets/animations/nodata_available.json'),
                          ),
                        ),
                ],
              ),
            )
          : Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: LottieBuilder.asset('assets/animations/loading.json'),
              ),
            ),
    );
  }
}
