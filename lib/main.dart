import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pre_school/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB8N1SBAv__hB9H5Mo2Bt3StYj0uICUt7s", // API Key
      appId: "1:169025738096:android:e4ceb227d3b54fc2c9abb5", // App ID
      messagingSenderId: "169025738096", // Sender ID
      projectId: "pre-school-88b37", // Project ID
      storageBucket: "pre-school-88b37.appspot.com", // Storage Bucket
    ),
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

// If there any problem please contact +94743399656 (WhatsApp)