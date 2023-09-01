import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget test(notiTime) {
  final dateTime = DateTime.parse(notiTime);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return Text('${difference.inSeconds} sec ago');
  } else if (difference.inMinutes < 60) {
    return Text('${difference.inMinutes} min ago');
  } else if (difference.inHours < 24) {
    return Text('${difference.inHours} hr ago');
  } else {
    final formatter = DateFormat('d MMMM yyyy');
    return Text(formatter.format(dateTime));
  }
}
