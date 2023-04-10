import 'package:flutter/material.dart';
import 'project1/home.dart';
import 'project1/add.dart';
import 'project1/update.dart';
import 'project1/splash.dart';
import 'project1/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Demo App",
      routes: {
        // '/': (context) => HomePage(), we dont need this one
        '/add': (context) => AddUser(),
        '/update': (context) => UpdateDonor(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),

      },
      initialRoute: '/splash',
    );
  }
}
