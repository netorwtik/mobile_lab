import 'package:flutter/material.dart';
import 'package:lab_5/simple_list.dart';
import 'package:lab_5/infinity_list.dart';
import 'package:lab_5/infinity_math_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const SimpleList()
      // home: const InfinityList()
      home: const InfinityMathList()
    );
  }
}
