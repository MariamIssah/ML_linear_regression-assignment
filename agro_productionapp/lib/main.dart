import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/first_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiseRural Connect',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF2D2D2D),
      ),
      home: const FirstPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
