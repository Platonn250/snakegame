// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snake/firebase_options.dart';
import 'package:snake/pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
