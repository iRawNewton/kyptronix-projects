import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../../constant/string_file.dart';
import '../../../dashboard/client/colorwidget.dart';
import '../../../sales/saleswidget.dart';
import 'question_smo.dart';

var tempUrl = AppUrl.hostingerUrl;

class QuestionSeo extends StatefulWidget {
  const QuestionSeo({super.key, required this.id});
  final String id;

  @override
  State<QuestionSeo> createState() => _QuestionSeoState();
}

class _QuestionSeoState extends State<QuestionSeo> {
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
            'https://crm.kyptronix.in/api_seo_filter.php?phone=${data1[0]['cli_phone']}'));

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
                                                  'Primary Goal: ${data2[index]['primary_goals']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'SEO Activities: ${data2[index]['seo_activities']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Product: ${data2[index]['product']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Target Audience: ${data2[index]['target_audience']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Location: ${data2[index]['location']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Specific Keyword: ${data2[index]['specific_keyword']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Google Analytic: ${data2[index]['google_analytic']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Organic Traffic: ${data2[index]['organic_traffic']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'SEO Knowledge: ${data2[index]['seo_knowledge']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'SEO Strategies: ${data2[index]['seo_strategies']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Specific Platform: ${data2[index]['specific_platform']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Off Page SEO: ${data2[index]['off_page_seo']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Influencer Marketing: ${data2[index]['influencer_marketing']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Content Marketing: ${data2[index]['content_marketing']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'URL: ${data2[index]['url']}',
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
                          builder: (context) => QuestionSmo(id: widget.id),
                        ),
                      );
                    },
                    child: const Text(
                      'Click to check for SMO Questionnaire',
                    ),
                  ),
                )
              ],
            )),
    );
  }
}

/*
 [{"web_id":"7","name":"Ramandeep ","email":"nagra.raman@gmail.com","phone":"4089306894","company":"","website":"","business":"Insurance ","purpose_website":"Insurance","target_audience":"","design_preference":"","functionality":"","domain_hosting":"","assistance":"","specific_integration":"","logo":"","inspiration_link":"","seo_research":"","multi_lang":"","timeline":"","budget":"","additional_info":"","custom_design":"Yes","ecomm_solution":"No","blog_section":"No","crm":"I donot know","support_package":"No","signup_amount":"100","estimate_cost":"500","additional_cost":"No","propose_timeline":"1 month","created_at":"2023-07-26"}]
*/

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class QuestionPage extends StatefulWidget {
//   const QuestionPage({super.key, required this.id});
//   final String id;
//   @override
//   State<QuestionPage> createState() => _QuestionPageState();
// }

// class _QuestionPageState extends State<QuestionPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       body: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: LottieBuilder.asset('assets/animations/workProgress.json'),
//       ),
//     ));
//   }
// }
