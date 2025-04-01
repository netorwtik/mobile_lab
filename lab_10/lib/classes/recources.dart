class Resources {
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
}