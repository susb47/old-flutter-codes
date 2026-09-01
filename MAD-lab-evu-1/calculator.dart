import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _currentNumber = '';
  String _operation = '';
  double _firstNumber = 0;
  bool _isOperationSelected = false;

  void _onDigitPress(String digit) {
    setState(() {
      if (_isOperationSelected) {
        _currentNumber = digit;
        _isOperationSelected = false;
      } else {
        if (_currentNumber == '0') {
          _currentNumber = digit;
        } else {
          _currentNumber += digit;
        }
      }
      _output = _currentNumber;
    });
  }

  void _onOperationPress(String operation) {
    setState(() {
      if (_currentNumber.isNotEmpty) {
        _firstNumber = double.parse(_currentNumber);
        _operation = operation;
        _isOperationSelected = true;
      } else if (_output != '0') {
        // Allow changing operation if one is already selected
        _operation = operation;
      }
    });
  }

  void _onEqualPress() {
    setState(() {
      if (_currentNumber.isNotEmpty && _operation.isNotEmpty) {
        double secondNumber = double.parse(_currentNumber);
        double result = 0;

        switch (_operation) {
          case '+':
            result = _firstNumber + secondNumber;
            break;
          case '-':
            result = _firstNumber - secondNumber;
            break;
          case '×':
            result = _firstNumber * secondNumber;
            break;
          case '÷':
            if (secondNumber != 0) {
              result = _firstNumber / secondNumber;
            } else {
              _output = 'Error';
              _currentNumber = '';
              _operation = '';
              _firstNumber = 0;
              return;
            }
            break;
        }

        _output = result.toString();
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
        _currentNumber = _output;
        _operation = '';
      }
    });
  }

  void _onClearPress() {
    setState(() {
      _output = '0';
      _currentNumber = '';
      _operation = '';
      _firstNumber = 0;
    });
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24.0),
            backgroundColor: color ?? Colors.white,
            foregroundColor: textColor ?? Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            if (text == 'C') {
              _onClearPress();
            } else if (text == '=') {
              _onEqualPress();
            } else if (text == '+' ||
                text == '-' ||
                text == '×' ||
                text == '÷') {
              _onOperationPress(text);
            } else {
              _onDigitPress(text);
            }
          },
          child: Text(text, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.black12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _operation.isNotEmpty ? '$_firstNumber $_operation' : '',
                    style: const TextStyle(fontSize: 24, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _output,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('÷', color: Colors.blue[100]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('×', color: Colors.blue[100]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-', color: Colors.blue[100]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('C', color: Colors.red[100]),
                    _buildButton('0'),
                    _buildButton(
                      '=',
                      color: Colors.green[300],
                      textColor: Colors.white,
                    ),
                    _buildButton('+', color: Colors.blue[100]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
