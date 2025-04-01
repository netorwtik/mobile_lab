class Machine {
  double _coffeeBeans = 0;
  double _milk = 0;
  double _water = 0;
  double _cash = 0;

  double getResource(String resource) {
    switch (resource) {
      case 'coffeeBeans':
        return _coffeeBeans;
      case 'milk':
        return _milk;
      case 'water':
        return _water;
      case 'cash':
        return _cash;
      default:
        return 0;
    }
  }

  void setResource(String resource, double value) {
    if (value < 0) return;

    switch (resource) {
      case 'coffeeBeans':
        _coffeeBeans = value;
        break;
      case 'milk':
        _milk = value;
        break;
      case 'water':
        _water = value;
        break;
      case 'cash':
        _cash = value;
        break;
    }
  }

  bool isAvailableResources(String coffeeType) {
    switch (coffeeType) {
      case 'espresso':
        return _coffeeBeans >= 50 && _water >= 100;
      case 'cappuccino':
        return _coffeeBeans >= 50 && _water >= 100 && _milk >= 50;
      case 'latte':
        return _coffeeBeans >= 50 && _water >= 100 && _milk >= 100;
      default:
        return false;
    }
  }

  void _subtractResources(double coffeeBeans, double milk, double water) {
    _coffeeBeans -= coffeeBeans;
    _milk -= milk;
    _water -= water;
  }

  bool makingCoffee(String coffeeType) {
    if (isAvailableResources(coffeeType)) {
      switch (coffeeType) {
        case 'espresso':
          _subtractResources(50, 0, 100);
          _cash += 2.0;
          return true;
        case 'cappuccino':
          _subtractResources(50, 50, 100);
          _cash += 3.0;
          return true;
        case 'latte':
          _subtractResources(50, 100, 100);
          _cash += 3.5;
          return true;
        default:
          return false;
      }
    }
    return false;
  }
}