import 'package:flutter/material.dart';

import './screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MyBait',
      home: LoginScreen(),
      routes: {
        // todo: implement each screen here with 'routeName'
      },
    );
  }
}
