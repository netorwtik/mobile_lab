enum CoffeeType {
  espresso,
  cappuccino,
  latte
}

extension CoffeeTypeExtension on CoffeeType {
  String get displayName {
    switch (this) {
      case CoffeeType.espresso:
        return 'Эспрессо';
      case CoffeeType.cappuccino:
        return 'Капучино';
      case CoffeeType.latte:
        return 'Латте';
      default:
        return toString();
    }
  }
}