import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

enum ConversionType { toCelsius, toFahrenheit }

class _ConverterScreenState extends State<ConverterScreen> {
  ConversionType? _conversionType = ConversionType.toCelsius;
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  List<String> _history = [];

  void _convert() {
    final input = double.tryParse(_controller.text);
    if (input == null) return;

    double convertedValue;
    String entry;

    if (_conversionType == ConversionType.toCelsius) {
      convertedValue = (input - 32) * 5 / 9;
      entry = "F to C: $input ➔ ${convertedValue.toStringAsFixed(2)}";
    } else {
      convertedValue = input * 9 / 5 + 32;
      entry = "C to F: $input ➔ ${convertedValue.toStringAsFixed(2)}";
    }

    setState(() {
      _result = convertedValue.toStringAsFixed(2);
      _history.insert(0, entry); // Most recent on top
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final converterControls = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Conversion:"),
        Row(
          children: [
            Expanded(
              child: RadioListTile<ConversionType>(
                title: const Text("Fahrenheit to Celsius"),
                value: ConversionType.toCelsius,
                groupValue: _conversionType,
                onChanged: (value) {
                  setState(() {
                    _conversionType = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<ConversionType>(
                title: const Text("Celsius to Fahrenheit"),
                value: ConversionType.toFahrenheit,
                groupValue: _conversionType,
                onChanged: (value) {
                  setState(() {
                    _conversionType = value;
                  });
                },
              ),
            ),
          ],
        ),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Enter temperature"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _convert,
          child: const Text("CONVERT"),
        ),
        const SizedBox(height: 10),
        Text("Converted Value: $_result", style: const TextStyle(fontSize: 18)),
      ],
    );

    final historyList = Expanded(
      child: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_history[index]),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLandscape
            ? Row(
                children: [
                  Expanded(child: converterControls),
                  const SizedBox(width: 20),
                  historyList,
                ],
              )
            : Column(
                children: [
                  converterControls,
                  const SizedBox(height: 20),
                  const Text("History:"),
                  historyList,
                ],
              ),
      ),
    );
  }
}
