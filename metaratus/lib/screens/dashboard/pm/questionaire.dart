import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../constant/string_file.dart';
import '../../sales/saleswidget.dart';
import '../client/colorwidget.dart';

var tempUrl = AppUrl.hostingerUrl;

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.id});
  final String id;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  dynamic data1;
  dynamic data2;
  // Future<void> getProjectList() async {
  //   var response = await http
  //       .post(Uri.parse('$tempUrl/project/question/question.php'), body: {
  //     'queryvalue': widget.id,
  //   });

  //   if (response.statusCode == 200) {
  //     if (response.body != 'Found Nothing') {
  //       data1 = jsonDecode(response.body);
  //       // var responseQue = await http.get(
  //       //   Uri.parse(
  //       //       'https://crm.kyptronix.in/api_web_filter.php?phone=${data1[0]['cli_phone']}'),
  //       // );
  //       // 4089306894
  //       var responseQue = await http.get(
  //         Uri.parse(
  //             'https://crm.kyptronix.in/api_web_filter.php?phone=4089306894'),
  //       );
  //       if (responseQue.statusCode == 200) {
  //         data2 = jsonDecode(responseQue.body);
  //         print(responseQue.body);
  //       } else {
  //         print('not found');
  //       }
  //     } else {}
  //   } else {
  //     // first one didnt 200
  //   }
  // }
  Future<dynamic> getFutureMethod = Future.value();
  dynamic data;
  bool toggleLoading = false;
  Widget hasValue = SizedBox(
      height: 90, child: LottieBuilder.asset('assets/animations/loading.json'));

  Future getProjectList() async {
    var responsei = await http
        .post(Uri.parse('$tempUrl/project/question/question.php'), body: {
      'queryvalue': widget.id,
    });
    if (responsei.statusCode == 200) {
      if (responsei.body != 'Found Nothing') {
        data1 = jsonDecode(responsei.body);
        //  call questionaire
        var response = await http.post(Uri.parse(
            'https://crm.kyptronix.in/api_web_filter.php?phone=${data1[0]['cli_phone']}'));

        if (response.statusCode == 200) {
          data2 = jsonDecode(response.body);

          if (data2.toString() != '{status: true, data: No data found}') {
            setState(() {
              toggleLoading = true;
            });
          } else {
            setState(() {
              toggleLoading = false;
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
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Name: ${data2[index]['name']}',
                                                    style: TextStyle(
                                                      fontFamily: 'fontTwo',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          MyColor.primaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            MySalesWidget(
                                              text:
                                                  'Email: ${data2[index]['email']}',
                                            ),
                                            // divider
                                            const Row(
                                              children: [
                                                Text(
                                                  'Contact Info',
                                                  style: TextStyle(
                                                    fontFamily: 'fontTwo',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Expanded(child: Divider()),
                                              ],
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Phone: ${data2[index]['phone']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Company: ${data2[index]['company']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Website: ${data2[index]['website']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Business: ${data2[index]['business']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Purpose Website: ${data2[index]['purpose_website']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Target Audience: ${data2[index]['target_audience']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Design Preference: ${data2[index]['design_preference']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Functionality: ${data2[index]['functionality']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Domain Hosting: ${data2[index]['domain_hosting']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Assistance: ${data2[index]['assistance']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Domain Hosting: ${data2[index]['domain_hosting']}',
                                            ),

                                            MySalesWidget(
                                              text:
                                                  'Specific Integration: ${data2[index]['specific_integration']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Logo: ${data2[index]['logo']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Inspiration Link: ${data2[index]['inspiration_link']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Seo Research: ${data2[index]['seo_research']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Multi Lang: ${data2[index]['multi_lang']}',
                                            ),

                                            MySalesWidget(
                                              text:
                                                  'Timeline: ${data2[index]['timeline']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Budget: ${data2[index]['budget']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Additional Info: ${data2[index]['additional_info']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Custom Design: ${data2[index]['custom_design']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Ecomm Solution: ${data2[index]['ecomm_solution']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Blog Section: ${data2[index]['blog_section']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'CRM: ${data2[index]['crm']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Support Package: ${data2[index]['support_package']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Signup Amount: ${data2[index]['signup_amount']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Estimate Cost: ${data2[index]['estimate_cost']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Additional Cost: ${data2[index]['additional_cost']}',
                                            ),
                                            MySalesWidget(
                                              text:
                                                  'Propose Timeline: ${data2[index]['propose_timeline']}',
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
          : Center(child: hasValue),
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
