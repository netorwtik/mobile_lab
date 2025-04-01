import 'Enums.dart';
import 'i_coffee.dart';

class Coffee implements ICoffee {
  final CoffeeType _type;

  Coffee(this._type);

  CoffeeType get type => _type;

  @override
  int coffeeBeans() {
    return 50;
  }

  @override
  int milk() {
    switch (_type) {
      case CoffeeType.espresso:
        return 0;
      case CoffeeType.cappuccino:
        return 100;
      case CoffeeType.latte:
        return 250;
      default:
        return 0;
    }
  }

  @override
  int water() {
    switch (_type) {
      case CoffeeType.espresso:
        return 100;
      case CoffeeType.cappuccino:
        return 100;
      case CoffeeType.latte:
        return 100;
      default:
        return 0;
    }
  }

  @override
  int cash() {
    switch (_type) {
      case CoffeeType.espresso:
        return 2;
      case CoffeeType.cappuccino:
        return 3;
      case CoffeeType.latte:
        return 4;
      default:
        return 0;
    }
  }
}