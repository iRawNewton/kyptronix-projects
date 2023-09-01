import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../constant/string_file.dart';

var tempUrl = AppUrl.hostingerUrl;

class EmailContact extends StatefulWidget {
  const EmailContact({super.key});

  @override
  State<EmailContact> createState() => _EmailContactState();
}

class _EmailContactState extends State<EmailContact> {
  dynamic data;

  getEmailContact() async {
    var response =
        await http.post(Uri.parse('$tempUrl/admin/email/getEmailList.php'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test')),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: getEmailContact(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (data.length > 0) {
                      return SizedBox(
                        height: 40,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Text(
                                '${data[index]['cli_name']}',
                                style: const TextStyle(
                                  fontFamily: 'fontTwo',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: LottieBuilder.asset(
                                  'assets/animations/loading.json')));
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}
