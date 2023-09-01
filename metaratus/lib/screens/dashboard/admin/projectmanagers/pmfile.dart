import 'dart:convert';

import 'package:client_onboarding_app/screens/dashboard/admin/projectmanagers/pmprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../../constant/string_file.dart';
import '../../../createuser/pm/createpm.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyPmList extends StatefulWidget {
  const MyPmList({super.key});

  @override
  State<MyPmList> createState() => _MyPmListState();
}

class _MyPmListState extends State<MyPmList> {
  var url = '$tempUrl/admin/ManagerList/managerList.php';

  dynamic data = [];
  // for calling
  String currentUsername = '';
  String cliName = '';
  String cliUsername = '';

  Future<void> getPmList() async {
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Managers',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade50,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            FutureBuilder(
                future: getPmList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (data.length == 0) {
                    return SizedBox(
                      child: Column(
                        children: [
                          LottieBuilder.asset(
                              'assets/animations/not_found.json'),
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
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPmProfile(
                                              id: data[index]['id'].toString(),
                                            )));
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                // color: Colors.blue.shade600,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  iconColor: Colors.white,
                                  tileColor: Colors.amber,
                                  title: Text(
                                    data[index]['cli_name'].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    data[index]['cli_phone'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(color: Colors.grey),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyNewPm()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}
