import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/firebase_options.dart';
import 'package:pre_school/screens/splash_screen.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: SplashScreen(),
    );
  }
}
