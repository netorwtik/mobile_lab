import 'package:flutter/material.dart';
import 'classes/Machine.dart';
import 'classes/Enums.dart';

void main() {
  runApp(CoffeeMachineApp());
}

class CoffeeMachineApp extends StatelessWidget {
  const CoffeeMachineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Machine',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown,
      ),
      home: CoffeeMachineHome(),
    );
  }
}

class CoffeeMachineHome extends StatefulWidget {
  const CoffeeMachineHome({super.key});

  @override
  _CoffeeMachineHomeState createState() => _CoffeeMachineHomeState();
}

class _CoffeeMachineHomeState extends State<CoffeeMachineHome> {
  final PageController _pageController = PageController();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _resourceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
          });
        },
        children: [
          CoffeeMakerPage(controller: _moneyController),
          ResourcesPage(controller: _resourceController),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _moneyController.dispose();
    _resourceController.dispose();
    super.dispose();
  }
}

class CoffeeMakerPage extends StatefulWidget {
  final TextEditingController controller;

  const CoffeeMakerPage({super.key, required this.controller});

  @override
  _CoffeeMakerPageState createState() => _CoffeeMakerPageState();
}

class _CoffeeMakerPageState extends State<CoffeeMakerPage> {
  final Machine _machine = Machine();
  CoffeeType _selectedCoffeeType = CoffeeType.espresso;
  String _message = "";
  bool _isPreparingCoffee = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Coffee Machine'),
        backgroundColor: Colors.brown,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.coffee, color: Colors.white),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          IconButton(
            icon: Icon(Icons.inventory, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResourcesPage(controller: TextEditingController())),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFCCDD78), // Светло-зеленый
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Beans: ${_machine.getResource('coffeeBeans').toInt()}'),
                    Text('Milk: ${_machine.getResource('milk').toInt()}'),
                    Text('Water: ${_machine.getResource('water').toInt()}'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Color(0xFFF5F5DC), // Светло-желтый
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.coffee, size: 30, color: Colors.brown),
                      SizedBox(width: 10),
                      Text(
                        'Coffee Maker',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your money: ${_machine.getResource('cash').toInt()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (_message.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(
                      _message,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                RadioListTile<CoffeeType>(
                  title: Row(
                    children: [
                      Icon(Icons.coffee, size: 20, color: Colors.brown[700]),
                      SizedBox(width: 8),
                      Text('espresso'),
                    ],
                  ),
                  value: CoffeeType.espresso,
                  groupValue: _selectedCoffeeType,
                  onChanged: _isPreparingCoffee
                      ? null
                      : (CoffeeType? value) {
                    setState(() {
                      _selectedCoffeeType = value!;
                    });
                  },
                ),
                RadioListTile<CoffeeType>(
                  title: Row(
                    children: [
                      Icon(Icons.coffee, size: 20, color: Colors.brown[700]),
                      SizedBox(width: 8),
                      Text('cappuccino'),
                    ],
                  ),
                  value: CoffeeType.cappuccino,
                  groupValue: _selectedCoffeeType,
                  onChanged: _isPreparingCoffee
                      ? null
                      : (CoffeeType? value) {
                    setState(() {
                      _selectedCoffeeType = value!;
                    });
                  },
                ),
                RadioListTile<CoffeeType>(
                  title: Row(
                    children: [
                      Icon(Icons.coffee, size: 20, color: Colors.brown[700]),
                      SizedBox(width: 8),
                      Text('latte'),
                    ],
                  ),
                  value: CoffeeType.latte,
                  groupValue: _selectedCoffeeType,
                  onChanged: _isPreparingCoffee
                      ? null
                      : (CoffeeType? value) {
                    setState(() {
                      _selectedCoffeeType = value!;
                    });
                  },
                ),

                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: 'Put money here',
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFD4E8B0), // Светло-зеленый
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.attach_money),
                        onPressed: _addMoney,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8B8C8), // Светло-розовый
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _collectCash,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF00A898),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: _isPreparingCoffee ? null : _makeCoffee,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addMoney() {
    double? amount = double.tryParse(widget.controller.text);
    if (amount != null && amount > 0) {
      setState(() {
        double current = _machine.getResource('cash');
        _machine.fillResources('cash', amount);
        widget.controller.clear();
        _message = 'Added \$${amount.toInt()} to your balance';
      });
    } else {
      setState(() {
        _message = 'Please enter a valid amount';
      });
    }
  }

  void _collectCash() {
    setState(() {
      double cash = _machine.getResource('cash');
      if (cash > 0) {
        _machine.fillResources('cash', -cash);
        _message = 'Collected \$${cash.toInt()}';
      } else {
        _message = 'No money to collect';
      }
    });
  }

  void _makeCoffee() async {
    if (_machine.isBusy) {
      setState(() {
        _message = 'Machine is busy';
      });
      return;
    }

    if (!_machine.isAvailableResources(_selectedCoffeeType)) {
      setState(() {
        _message = 'Not enough resources';
      });
      return;
    }

    setState(() {
      _isPreparingCoffee = true;
      _message = 'Preparing ${_selectedCoffeeType.displayName}...';
    });

    bool success = await _machine.makeCoffeeByTypeAsync(_selectedCoffeeType);

    setState(() {
      _isPreparingCoffee = false;
      if (success) {
        _message = 'Your ${_selectedCoffeeType.displayName} is ready!';
      } else {
        _message = 'Failed to make coffee';
      }
    });
  }
}

class ResourcesPage extends StatefulWidget {
  final TextEditingController controller;

  const ResourcesPage({super.key, required this.controller});

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final Machine _machine = Machine();
  String _selectedResource = 'milk';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Coffee Machine'),
        backgroundColor: Colors.brown,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.coffee, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoffeeMakerPage(controller: TextEditingController())),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.inventory, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFCCDD78),
              width: double.infinity,
              child: Column(
                children: [
                  // Ресурсы
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5DC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory, size: 28, color: Colors.brown),
                              SizedBox(width: 10),
                              Text(
                                'Resources:',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildResourceItem('Milk:', '${_machine.getResource('milk').toInt()}', Icons.opacity),
                          _buildResourceItem('Water:', '${_machine.getResource('water').toInt()}', Icons.water_drop),
                          _buildResourceItem('Beans:', '${_machine.getResource('coffeeBeans').toInt()}', Icons.coffee),
                          _buildResourceItem('Cash:', '${_machine.getResource('cash').toInt()}', Icons.attach_money),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildResourceInput('put milk', 'milk', Icons.opacity),
                Divider(),
                _buildResourceInput('put water', 'water', Icons.water_drop),
                Divider(),
                _buildResourceInput('put beans', 'coffeeBeans', Icons.coffee),
                Divider(),
                _buildResourceInput('put cash', 'cash', Icons.attach_money),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFC8E6C9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addResource,
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFCDD2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _removeResource,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.brown[400]),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceInput(String hint, String resourceKey, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedResource = resourceKey;
        });
      },
      child: Row(
        children: [
          Icon(icon, size: 18, color: _selectedResource == resourceKey ? Colors.brown : Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _selectedResource == resourceKey ? widget.controller : TextEditingController(),
              enabled: _selectedResource == resourceKey,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  void _addResource() {
    double? amount = double.tryParse(widget.controller.text);
    if (amount != null && amount > 0) {
      setState(() {
        _machine.fillResources(_selectedResource, amount);
        widget.controller.clear();
      });
    }
  }

  void _removeResource() {
    double? amount = double.tryParse(widget.controller.text);
    if (amount != null && amount > 0) {
      double current = _machine.getResource(_selectedResource);

      if (amount > current) amount = current;

      if (amount > 0) {
        setState(() {
          _machine.fillResources(_selectedResource, -amount!);
          widget.controller.clear();
        });
      }
    }
  }
}