import 'dart:convert';

import 'package:http/http.dart' as http;

var url = 'http://10.0.2.2:80/clientonboarding/get.php';

var hostingerUrl = 'https://metaratus.kyptronixllp.co.in/FlutterApi/';

dynamic data;
Future<void> getTaskDetailsss() async {
  final response = await http.get(
    Uri.parse('url'),
  );

  if (response.statusCode == 200) {
    data = jsonDecode(response.body.toString());
  }
}
