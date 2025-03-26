import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  const SimpleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Список элементов',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('0000')
          ),
          ListTile(
              title: Text('0001')
          ),
          ListTile(
              title: Text('0010')
          ),
        ],
      )
    );
  }
}