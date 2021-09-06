import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cancoin_wallet/app.dart';


Future<void> mainEntry(String env) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}