import 'package:flutter/material.dart';
import 'screens/account_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '口座管理アプリ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AccountListScreen(),
    );
  }
}
