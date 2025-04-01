import 'package:lab_9/classes/recources.dart';

import 'Enums.dart';
import 'Coffee.dart';
import 'i_coffee.dart';

class Machine {
  final Resources _resources = Resources();

  Machine() {
    _resources.setResource('coffeeBeans', 200);
    _resources.setResource('milk', 500);
    _resources.setResource('water', 1000);
  }

  double getResource(String resource) {
    return _resources.getResource(resource);
  }

  void fillResources(String resource, double amount) {
    if (amount <= 0) return;

    double current = _resources.getResource(resource);
    _resources.setResource(resource, current + amount);
  }

  bool isAvailableResources(CoffeeType coffeeType) {
    ICoffee coffee = Coffee(coffeeType);

    return _resources.getResource('coffeeBeans') >= coffee.coffeeBeans() &&
        _resources.getResource('milk') >= coffee.milk() &&
        _resources.getResource('water') >= coffee.water();
  }

  bool makeCoffeeByType(CoffeeType coffeeType) {
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

  bool makeCoffee() {
    return makeCoffeeByType(CoffeeType.espresso);
  }

  void _subtractResources(double coffeeBeans, double milk, double water) {
    double currentBeans = _resources.getResource('coffeeBeans');
    double currentMilk = _resources.getResource('milk');
    double currentWater = _resources.getResource('water');

    _resources.setResource('coffeeBeans', currentBeans - coffeeBeans);
    _resources.setResource('milk', currentMilk - milk);
    _resources.setResource('water', currentWater - water);
  }
}