import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodpanda_riders_app/firebase_options.dart';
import 'package:foodpanda_riders_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/global.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
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
      debugShowCheckedModeBanner: false,
      title: 'Riders App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}