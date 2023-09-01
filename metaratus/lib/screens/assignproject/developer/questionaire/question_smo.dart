import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../../constant/string_file.dart';
import '../../../dashboard/client/colorwidget.dart';
import '../../../sales/saleswidget.dart';
import 'question_seo.dart';

var tempUrl = AppUrl.hostingerUrl;

class QuestionSmo extends StatefulWidget {
  const QuestionSmo({super.key, required this.id});
  final String id;

  @override
  State<QuestionSmo> createState() => _QuestionSmoState();
}

class _QuestionSmoState extends State<QuestionSmo> {
  dynamic data1;
  dynamic data2;
  bool isVisible = false;

  Future<dynamic> getFutureMethod = Future.value();
  dynamic data;
  bool toggleLoading = false;
  Widget hasValue = SizedBox(
      height: 90, child: LottieBuilder.asset('assets/animations/loading.json'));

  Future getProjectList() async {
    var responsei = await http
        .post(Uri.parse('$tempUrl/project/question/question_dev.php'), body: {
      'queryvalue': widget.id,
    });

    if (responsei.statusCode == 200) {
      if (responsei.body != 'Found Nothing') {
        data1 = jsonDecode(responsei.body);
        //  call questionaire
        var response = await http.post(Uri.parse(
            'https://crm.kyptronix.in/api_smo_filter.php?phone=${data1[0]['cli_phone']}'));

        if (response.statusCode == 200) {
          data2 = jsonDecode(response.body);

          if (data2.toString() != '{status: true, data: No data found}') {
            setState(() {
              toggleLoading = true;
            });
          } else {
            setState(() {
              toggleLoading = false;
              isVisible = true;
              hasValue = LottieBuilder.asset(
                  'assets/animations/nodata_available.json');
            });
          }
        }
        //  call questionaire
      }
    }
  }

  @override
  void initState() {
    getFutureMethod = getProjectList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Questionaire Form',
          style: TextStyle(
            fontFamily: 'fontOne',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
      ),
      body: toggleLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade200,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getFutureMethod,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (data2.length > 0) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data2.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10),
                                  child: Container(
                                    // height: 150,
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(0, 0, 0, 0.10),
                                      )
                                    ]),
                                    child: Card(
                                      elevation: 0,
                                      color: MyColor.projectCard,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 5, 10),
                                        child: Column(
                                          children: [
                                            MySalesWidget(
                                              text:
                                                  'Company: ${data2[index]['company']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Social Media: ${data2[index]['social_media']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Social Media Presence: ${data2[index]['social_media_presence']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Media Platform: ${data2[index]['media_platform']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Social Media Optimize: ${data2[index]['social_media_optimize']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Social Media Goals: ${data2[index]['social_media_goals']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Target Audience: ${data2[index]['target_audience']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Social Media Credential: ${data2[index]['social_media_credential']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Share Credentials: ${data2[index]['share_credentials']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Advertising: ${data2[index]['advertising']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Blog Articles: ${data2[index]['blog_articles']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Blog Links: ${data2[index]['blog_link']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Influencer Marketing: ${data2[index]['influencer_marketing']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Multi Language: ${data2[index]['multi_lang']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Content Marketing: ${data2[index]['content_marketing']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Content Type: ${data2[index]['content_type']}',
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: LottieBuilder.asset(
                                      'assets/animations/loading.json')));
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasValue,
                Visibility(
                  visible: isVisible,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionSeo(id: widget.id),
                        ),
                      );
                    },
                    child: const Text(
                      'Click to check for SEO Questionnaire',
                    ),
                  ),
                )
              ],
            )),
    );
  }
}
