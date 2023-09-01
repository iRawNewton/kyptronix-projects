import 'dart:convert';

import 'package:client_onboarding_app/screens/createuser/client/createcli.dart';
import 'package:client_onboarding_app/screens/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/string_file.dart';
import '../dashboard/client/colorwidget.dart';
import 'package:url_launcher/url_launcher.dart';

var tempUrl = AppUrl.hostingerUrl;

class MyClientList extends StatefulWidget {
  const MyClientList({super.key});

  @override
  State<MyClientList> createState() => _MyClientListState();
}

class _MyClientListState extends State<MyClientList> {
  TextEditingController searchValue = TextEditingController();
  dynamic data = [];
  Future<dynamic> getFutureMethod = Future.value();
  bool showCard = true;
  bool recordPresent = true;

  Future getClientList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pmID = prefs.getString('pmId');

    var response = await http
        .post(Uri.parse('$tempUrl/client/getEntireClientList.php'), body: {
      'pm_id': pmID,
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      if (data.length == 0) {
        setState(() {
          recordPresent = false;
        });
      } else {
        setState(() {
          showCard = true;
        });
      }
    }
  }

  searchClientList(clientId) async {
    var response =
        await http.post(Uri.parse('$tempUrl/client/searchClient.php'), body: {
      'queryvalue': clientId.text,
    });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      // setState(() {
      //   isVisible = !isVisible;
      //   isNotLoading = true;
      //   showRecord = true;
      // });
    } else {
      // setState(() {
      //   isVisible = true;
      // });
    }
  }

  // delete function
  deleteData(clientId) async {
    var response =
        await http.post(Uri.parse('$tempUrl/client/deleteClient.php'), body: {
      'id': clientId.toString(),
    });
    if (response.statusCode == 200) {
      setState(() {
        getFutureMethod = getClientList();
        showCard = true;
      });
    } else {}
  }

  void launchWhatsApp(number) async {
    final Uri whatsApp = Uri.parse('https://wa.me/$number?');
    launchUrl(whatsApp, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    setState(() {
      getFutureMethod = getClientList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          centerTitle: true,
          title: const Text(
            'Kyptronix Clients',
            style: TextStyle(
              fontFamily: 'fontOne',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: recordPresent
            ? Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // search
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      controller: searchValue,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              getFutureMethod =
                                                  searchClientList(searchValue);
                                            });
                                          },
                                          icon: const Icon(Icons.search),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // future builder
                      showCard
                          ? FutureBuilder(
                              future: getFutureMethod,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (data.length > 0) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 10),
                                          child: Container(
                                            // height: 150,
                                            decoration:
                                                const BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.10),
                                              )
                                            ]),
                                            child: Card(
                                              elevation: 0,
                                              color: MyColor.projectCard,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 5, 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Name: ${data[index]['cli_name']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'fontTwo',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: MyColor
                                                                .primaryText,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                launchWhatsApp(
                                                                    7908170647);
                                                              },
                                                              icon: Image.asset(
                                                                  'assets/images/whatsapp.png')),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Username: ${data[index]['cli_userid']}',
                                                        style: TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyColor
                                                              .primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'E-mail: ${data[index]['cli_email']}',
                                                        style: TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyColor
                                                              .primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Phone No. : ${data[index]['cli_phone']}',
                                                        style: TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyColor
                                                              .primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Designation: ${data[index]['cli_designation']}',
                                                        style: TextStyle(
                                                          fontFamily: 'fontTwo',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyColor
                                                              .primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          child: ElevatedButton
                                                              .icon(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => MyPmCreateClient(
                                                                          caseOperation:
                                                                              'update',
                                                                          clientID:
                                                                              data[index]['id'])));
                                                            },
                                                            icon: const Icon(
                                                              Icons.update,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: const Text(
                                                              'UPDATE',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'fontThree',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            style: const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                                        Colors
                                                                            .blue)),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          child: ElevatedButton
                                                              .icon(
                                                            onPressed: () {
                                                              showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return CupertinoAlertDialog(
                                                                    title: Text(
                                                                      'Delete client ${data[index]['cli_name']}',
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'fontOne',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                      'This action cannot be undone',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'fontTwo',
                                                                      ),
                                                                    ),
                                                                    actions: <Widget>[
                                                                      CupertinoDialogAction(
                                                                        child:
                                                                            const Text(
                                                                          'Cancel',
                                                                          style:
                                                                              TextStyle(color: Colors.blue),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      CupertinoDialogAction(
                                                                        child:
                                                                            const Text(
                                                                          'OK',
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            showCard =
                                                                                false;
                                                                          });
                                                                          deleteData(data[index]
                                                                              [
                                                                              'id']);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: const Text(
                                                              'DELETE',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'fontThree',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                            ),
                                                            style: const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                                        Colors
                                                                            .red)),
                                                          ),
                                                        ),
                                                      ],
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: LottieBuilder.asset(
                                              'assets/animations/loading.json')));
                                }
                              },
                            )
                          : Center(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: LottieBuilder.asset(
                                      'assets/animations/loading.json'))),
                    ],
                  ),
                ),
              )
            : Center(
                child: LottieBuilder.asset(
                    'assets/animations/nodata_available.json'),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade100,
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyPmCreateClient(
                        caseOperation: 'create', clientID: '0')));
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        drawer: const MyDrawerInfo(),
      ),
    );
  }
}
