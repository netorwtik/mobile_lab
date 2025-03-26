import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)
        ),
        home: const MyForm()
    )
);

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  String _width = '';
  String _height = '';
  String _result = 'Задайте параметры';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Калькулятор площади',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Ширина (мм)'),
              TextFormField(
                onSaved: (value) {
                  _width = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Задайте Ширину';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Высота (мм)'),
              TextFormField(
                onSaved: (value) {
                  _height = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Задайте Высоту';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      int width = int.parse(_width);
                      int height = int.parse(_height);
                      int area = width * height;

                      setState(() {
                        _result = 'S = $width * $height = $area (мм2)';
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Площадь успешно вычислена!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('Вычислить', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}