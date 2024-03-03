import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:hydrobloomapp/screens/LogInPage.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HydroBloom',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 42, 222, 204),
      ),
      home: LogInPage(),
    );
  }
}



