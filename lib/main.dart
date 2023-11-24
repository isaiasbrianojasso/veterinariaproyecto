import 'package:flutter/material.dart';
import 'login.dart';

//import 'package:PROYECTO-1/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veterinaria',
      theme: ThemeData(primarySwatch: Colors.green),
        home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
