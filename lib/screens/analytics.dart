import 'package:flutter/material.dart';
import 'package:personal_expenses_tracker/screens/chart/chart.dart';

import '../models/expense.dart';
import '../widgets/main_drawer.dart';
import 'configurations.dart';
import 'expenses.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'settings') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return const Configurations();
          },
        ),
      );
    }
    if (identifier == 'analytics') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return const Analytics();
          },
        ),
      );
    }
    if (identifier == 'expenses') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return const Expenses();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List<Widget> screenContent = [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        width: 180,
        height: 180,
        margin: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Saldo total',
                  style: Theme.of(context).textTheme.titleSmall),
              Text('R\$1.000', style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
      ),
      // Chart(expenses: _registeredExpenses),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text('Analytics'),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: Center(
        child: width > 600
            ? Row(
                children: screenContent,
              )
            : Column(
                children: screenContent,
              ),
      ),
    );
  }
}
