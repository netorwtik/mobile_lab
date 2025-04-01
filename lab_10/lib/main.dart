import 'package:flutter/material.dart';

import 'classes/Coffee.dart';
import 'classes/Enums.dart';
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

          // Make coffee
          Text('Приготовить кофе:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),

          // Используем CoffeeType из перечисления
          for (var coffeeType in CoffeeType.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () => _makeCoffee(coffeeType),
                child: Text(_getCoffeeButtonText(coffeeType)),
              ),
            ),

          Divider(height: 32),

          // Message display
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

          // Collect cash
          ElevatedButton(
            onPressed: _collectCash,
            child: Text('Забрать деньги'),
          ),
        ],
      ),
    );
  }

  String _getCoffeeButtonText(CoffeeType type) {
    var coffee = Coffee(type);
    return '${type.displayName} (${coffee.coffeeBeans()}г зерен, ${coffee.milk() > 0 ? '${coffee.milk()}мл молока, ' : ''}${coffee.water()}мл воды)';
  }

  void _addResource() {
    double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        _machine.fillResources(_selectedResource, amount);

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

  void _makeCoffee(CoffeeType coffeeType) {
    setState(() {
      if (_machine.isAvailableResources(coffeeType)) {
        bool success = _machine.makeCoffeeByType(coffeeType);
        if (success) {
          _message = 'Ваш ${coffeeType.displayName} готов!';
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
      _machine.fillResources('cash', -cash);
      _message = 'Вы забрали ${cash.toStringAsFixed(2)}₽ из машины';
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}