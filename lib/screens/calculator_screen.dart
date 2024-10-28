import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../utils/calculator_utils.dart';
import '../utils/colors.dart';
import '../widgets/button.dart';
import '../widgets/display.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = "";
  String _result = "0";
  bool isRadMode = true;
  String _lastAnswer = "0";

  void _onButtonPressed(String value) {
    setState(() {
      switch (value) {
        case "=":
          _calculateResult();
          break;
        case "AC":
          _expression = "";
          _result = "0";
          break;
        case "DEL":
          _expression = _expression.isNotEmpty
              ? _expression.substring(0, _expression.length - 1)
              : "";
          break;
        case "Rad":
        case "Deg":
          isRadMode = !isRadMode;
          break;
        case "π":
          _expression += "3.141592653589793";
          break;
        case "e":
          _expression += "2.718281828459045";
          break;
        case "Ans":
          _expression += _lastAnswer;
          break;
        case "x!":
          _expression += "!";
          break;
        case "√":
          _expression += "sqrt(";
          break;
        case "EXP":
          _expression += "exp(";
          break;
        case "xⁿ":
          _expression += "^";
          break;
        case "sin":
        case "cos":
        case "tan":
        case "log":
        case "ln":
          _expression += "$value(";
          break;
        default:
          _expression += value;
      }
    });
  }

  void _calculateResult() {
    try {
      String expression = CalculatorUtils.preprocessFactorials(_expression);
      Parser parser = Parser();
      Expression exp = parser.parse(expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('^', '^')
          .replaceAll('sqrt', 'sqrt'));

      ContextModel contextModel = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      _lastAnswer = eval.toString();
      _result = eval.toString();
    } catch (e) {
      _result = "Error";
    }
  }

  Widget buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: labels.map((label) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CalculatorButton(
                label: label,
                onTap: () => _onButtonPressed(label),
                isOperation: [
                  "=",
                  "AC",
                  "DEL",
                  "Rad",
                  "Deg",
                  "sin",
                  "cos",
                  "tan",
                  "ln",
                  "π",
                  "e",
                  "Ans",
                  "EXP",
                  "x!",
                  "√",
                  "xⁿ"
                ].contains(label),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: <Widget>[
            Display(expression: _expression, result: _result),
            Expanded(
              child: Column(
                children: [
                  buildButtonRow(["Rad", "Deg", "x!", "DEL"]),
                  buildButtonRow(["sin", "cos", "tan", "ln"]),
                  buildButtonRow(["π", "e", "√", "EXP"]),
                  buildButtonRow(["7", "8", "9", "/"]),
                  buildButtonRow(["4", "5", "6", "×"]),
                  buildButtonRow(["1", "2", "3", "-"]),
                  buildButtonRow(["0", ".", "Ans", "+"]),
                  buildButtonRow(["AC", "(", ")", "="]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
