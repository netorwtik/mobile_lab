import 'package:flutter/material.dart';
import 'dart:math' as math;

class InfinityMathList extends StatelessWidget {
  const InfinityMathList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Список элементов',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          BigInt result = BigInt.from(2).pow(index); // Используем BigInt

          return ListTile(
            title: Text('2^$index = $result'),
          );
        },
      ),
    );
  }
}
