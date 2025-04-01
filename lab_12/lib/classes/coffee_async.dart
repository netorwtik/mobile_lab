import 'dart:async';
import 'Enums.dart';

class CoffeeAsync {

  static Future<bool> heatWater() async {
    print('Нагрев воды...');
    await Future.delayed(Duration(seconds: 3));
    print('Вода нагрета!');
    return true;
  }

  static Future<bool> brewCoffee() async {
    print('Заваривание кофе...');
    await Future.delayed(Duration(seconds: 5));
    print('Кофе заварено!');
    return true;
  }

  static Future<bool> whipMilk() async {
    print('Взбивание молока...');
    await Future.delayed(Duration(seconds: 5));
    print('Молоко взбито!');
    return true;
  }

  static Future<bool> mixCoffeeAndMilk() async {
    print('Смешивание кофе и молока...');
    await Future.delayed(Duration(seconds: 3));
    print('Кофе и молоко смешаны!');
    return true;
  }

  static Future<bool> makeCoffeeAsync(CoffeeType coffeeType) async {
    print('Начало приготовления ${coffeeType.displayName}...');

    await heatWater();

    if (coffeeType == CoffeeType.cappuccino || coffeeType == CoffeeType.latte) {
      final Future<bool> coffeeFuture = brewCoffee();
      final Future<bool> milkFuture = whipMilk();

      await Future.wait([coffeeFuture, milkFuture]);

      await mixCoffeeAndMilk();
    } else {
      await brewCoffee();
    }

    print('${coffeeType.displayName} готово!');
    return true;
  }
}