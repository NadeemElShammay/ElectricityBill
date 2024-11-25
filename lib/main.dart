import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CalculationWidget(),
      ),
    );
  }
}

class CalculationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CalculationBody(),
      ),
    );
  }
}

class CalculationBody extends StatefulWidget {
  @override
  _CalculationBodyState createState() => _CalculationBodyState();
}

class _CalculationBodyState extends State<CalculationBody> {
  double previousReading = 0;
  double currentReading = 0;
  double pricePerKwh = 0;
  double usage = 0;
  double addTax = 0;
  double total = 0;

  void calculateUsage() {
    setState(() {
      usage = currentReading - previousReading;
      calculateTotal();
    });
  }

  void calculateTotal() {
    setState(() {
      total = (usage * pricePerKwh) + addTax;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'ELECTRICITY BILL',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('Previous Reading (KWh):', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  previousReading = double.tryParse(value) ?? 0;
                  calculateUsage();
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Current Reading (KWh):', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  currentReading = double.tryParse(value) ?? 0;
                  calculateUsage();
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Usage (KWh):', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              usage.toStringAsFixed(2),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tax Per Ampaire:', style: TextStyle(fontSize: 18)),
            ...[5, 10, 15, 20].map((tax) {
              double addition;
              switch (tax) {
                case 5:
                  addition = 5;
                  break;
                case 10:
                  addition = 7.5;
                  break;
                case 15:
                  addition = 10;
                  break;
                case 20:
                  addition = 12.5;
                  break;
                default:
                  addition = 0;
              }
              return RadioListTile<double>(
                title: Text('$tax amps'),
                value: addition,
                groupValue: addTax,
                onChanged: (value) {
                  setState(() {
                    addTax = value ?? 0;
                    calculateTotal();
                  });
                },
              );
            }).toList(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('KWh Rate:', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  pricePerKwh = double.tryParse(value) ?? 0;
                  calculateTotal();
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Total Cost:', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              total.toStringAsFixed(2),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
