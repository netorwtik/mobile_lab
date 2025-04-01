import 'package:flutter/material.dart';
import 'classes/Machine.dart';

void main() {
  runApp(CoffeeMachineApp());
}

class CoffeeMachineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        brightness: Brightness.light,
      ),
      home: CoffeeMachineScreen(),
    );
  }
}

class CoffeeMachineScreen extends StatefulWidget {
  @override
  _CoffeeMachineScreenState createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  final Machine _machine = Machine();
  String _message = "";
  final TextEditingController _amountController = TextEditingController();
  String _selectedResource = 'coffeeBeans';

  @override
  void initState() {
    super.initState();
    _machine.setResource('coffeeBeans', 200);
    _machine.setResource('milk', 300);
    _machine.setResource('water', 500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кофемашина'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('Ресурсы:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Кофейные зерна: ${_machine.getResource('coffeeBeans')}г'),
          Text('Молоко: ${_machine.getResource('milk')}мл'),
          Text('Вода: ${_machine.getResource('water')}мл'),
          Text('Деньги: ${_machine.getResource('cash').toStringAsFixed(2)}₽'),

          Divider(height: 32),

          Text('Добавить ресурс:', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedResource,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: 'coffeeBeans', child: Text('Кофейные зерна')),
              DropdownMenuItem(value: 'milk', child: Text('Молоко')),
              DropdownMenuItem(value: 'water', child: Text('Вода')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedResource = value!;
              });
            },
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Количество',
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addResource,
                child: Text('Добавить'),
              ),
            ],
          ),

          Divider(height: 32),

          Text('Приготовить кофе:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _makeCoffee('espresso'),
            child: Text('Эспрессо (50г зерен, 100мл воды)'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _makeCoffee('cappuccino'),
            child: Text('Капучино (50г зерен, 50мл молока, 100мл воды)'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _makeCoffee('latte'),
            child: Text('Латте (50г зерен, 100мл молока, 100мл воды)'),
          ),

          Divider(height: 32),

          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),

          ElevatedButton(
            onPressed: _collectCash,
            child: Text('Забрать деньги'),
          ),
        ],
      ),
    );
  }

  void _addResource() {
    double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        double currentAmount = _machine.getResource(_selectedResource);
        _machine.setResource(_selectedResource, currentAmount + amount);

        String resourceName;
        switch (_selectedResource) {
          case 'coffeeBeans':
            resourceName = 'кофейных зерен';
            break;
          case 'milk':
            resourceName = 'молока';
            break;
          case 'water':
            resourceName = 'воды';
            break;
          default:
            resourceName = '';
        }

        _message = 'Добавлено $amount $resourceName';
        _amountController.clear();
      });
    } else {
      setState(() {
        _message = 'Пожалуйста, введите корректное количество';
      });
    }
  }

  void _makeCoffee(String coffeeType) {
    setState(() {
      if (_machine.isAvailableResources(coffeeType)) {
        bool success = _machine.makingCoffee(coffeeType) as bool;
        if (success) {
          String coffeeName;
          switch (coffeeType) {
            case 'espresso':
              coffeeName = 'Эспрессо';
              break;
            case 'cappuccino':
              coffeeName = 'Капучино';
              break;
            case 'latte':
              coffeeName = 'Латте';
              break;
            default:
              coffeeName = coffeeType;
          }
          _message = 'Ваш $coffeeName готов!';
        } else {
          _message = 'Ошибка при приготовлении кофе.';
        }
      } else {
        _message = 'Недостаточно ресурсов для приготовления.';
      }
    });
  }

  void _collectCash() {
    setState(() {
      double cash = _machine.getResource('cash');
      _machine.setResource('cash', 0);
      _message = 'Вы забрали ${cash.toStringAsFixed(2)}₽ из машины';
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}