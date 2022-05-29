import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';


import 'package:view/APILog.dart';
import 'package:view/Register.dart';
import 'package:view/login.dart';
import 'package:view/Status.dart';
import 'package:view/AddDevice.dart';

import 'APIID_Device.dart';
import 'chart.dart';
import 'testSesstionReal.dart';
import 'notification.dart';
import 'notification_setting.dart';
import 'Export.dart';

main() async{
  await GetStorage.init();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      home : LoginDemo(),
  );
}