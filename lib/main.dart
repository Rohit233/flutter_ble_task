import 'package:flutter/material.dart';
import 'package:flutter_ble/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter BLE',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black
          ),
          titleTextStyle: Theme.of(context).textTheme.headline5,
          backgroundColor: Colors.white
        ),
        primarySwatch: Colors.blue,
      ),
      home: const Home()
    );
  }
}
