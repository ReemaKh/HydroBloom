import 'package:flutter/material.dart';
import 'package:hydrobloomapp/screens/LogInPage.dart';
import 'package:hydrobloomapp/widgets/my_garden_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GardenModel(),
      child: MaterialApp(
        title: 'HydroBloom',
        theme: ThemeData(
          primaryColor: Color(0xFF009688),
        ),
        home: LogInPage(),
      ),
    );
  }
}


