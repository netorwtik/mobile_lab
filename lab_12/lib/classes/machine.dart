
import 'package:lab_9/classes/recources.dart';

import 'Coffee.dart';
import 'Enums.dart';
import 'coffee_async.dart';
import 'i_coffee.dart';

class Machine {
  final Resources _resources = Resources();
  bool _isMakingCoffee = false;

  Machine() {
    _initResources();
  }

  factory Machine.withDemo() {
    final machine = Machine();
    machine._runDemo();
    return machine;
  }

  void _initResources() {
    _resources.setResource('coffeeBeans', 250);
    _resources.setResource('milk', 250);
    _resources.setResource('water', 250);
    _resources.setResource('cash', 0);
  }

  Future<void> _runDemo() async {
    print('--- Демонстрация работы кофемашины ---');

    for (var type in CoffeeType.values) {
      await Future.delayed(Duration(seconds: 2));
      print('\nДемонстрация приготовления: ${type.displayName}');
      if (isAvailableResources(type)) {
        await makeCoffeeByTypeAsync(type);
      } else {
        print('Недостаточно ресурсов для ${type.displayName}');
      }
    }

    print('\n--- Демонстрация завершена ---');
  }

  double getResource(String resource) {
    return _resources.getResource(resource);
  }

  bool get isBusy => _isMakingCoffee;

  void fillResources(String resource, double amount) {
    if (amount <= 0 && resource != 'cash') return;

    double current = _resources.getResource(resource);
    _resources.setResource(resource, current + amount);

    print('Ресурс $resource изменен. Новое значение: ${_resources.getResource(resource)}');
  }

  bool isAvailableResources(CoffeeType coffeeType) {
    ICoffee coffee = Coffee(coffeeType);

    return _resources.getResource('coffeeBeans') >= coffee.coffeeBeans() &&
        _resources.getResource('milk') >= coffee.milk() &&
        _resources.getResource('water') >= coffee.water();
  }

  bool makeCoffeeByType(CoffeeType coffeeType) {
    if (_isMakingCoffee) {
      print('Машина уже занята приготовлением кофе');
      return false;
    }

    if (isAvailableResources(coffeeType)) {
      ICoffee coffee = Coffee(coffeeType);

      _subtractResources(
          coffee.coffeeBeans().toDouble(),
          coffee.milk().toDouble(),
          coffee.water().toDouble()
      );

      double currentCash = _resources.getResource('cash');
      _resources.setResource('cash', currentCash + coffee.cash());

      return true;
    }
    return false;
  }

  Future<bool> makeCoffeeByTypeAsync(CoffeeType coffeeType) async {
    if (_isMakingCoffee) {
      print('Машина уже занята приготовлением кофе');
      return false;
    }

    if (!isAvailableResources(coffeeType)) {
      print('Недостаточно ресурсов для приготовления ${coffeeType.displayName}');
      return false;
    }

    _isMakingCoffee = true;

    try {
      ICoffee coffee = Coffee(coffeeType);

      _subtractResources(
          coffee.coffeeBeans().toDouble(),
          coffee.milk().toDouble(),
          coffee.water().toDouble()
      );

      await CoffeeAsync.makeCoffeeAsync(coffeeType);

      double currentCash = _resources.getResource('cash');
      _resources.setResource('cash', currentCash + coffee.cash());

      _isMakingCoffee = false;
      return true;
    } catch (e) {
      print('Ошибка при приготовлении кофе: $e');
      _isMakingCoffee = false;
      return false;
    }
  }

  bool makeCoffee() {
    return makeCoffeeByType(CoffeeType.espresso);
  }

  Future<bool> makeCoffeeAsync() async {
    return await makeCoffeeByTypeAsync(CoffeeType.espresso);
  }

  void _subtractResources(double coffeeBeans, double milk, double water) {
    double currentBeans = _resources.getResource('coffeeBeans');
    double currentMilk = _resources.getResource('milk');
    double currentWater = _resources.getResource('water');

    _resources.setResource('coffeeBeans', currentBeans - coffeeBeans);
    _resources.setResource('milk', currentMilk - milk);
    _resources.setResource('water', currentWater - water);

    print('Ресурсы уменьшены: зерна -$coffeeBeans, молоко -$milk, вода -$water');
  }
}