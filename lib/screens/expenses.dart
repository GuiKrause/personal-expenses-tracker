import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_expenses_tracker/screens/analytics.dart';
import 'package:personal_expenses_tracker/screens/configurations.dart';
import 'package:http/http.dart' as http;

import '../models/expense.dart';
import '../widgets/main_drawer.dart';
import 'expenses_list/expenses_list.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Expense> _expenseItems = [];
  var _isloading = true;
  String? _error;

  final url = Uri.https(
      'personal-expenses-tracker-0-default-rtdb.firebaseio.com',
      'expenses.json');

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _openAddExpenseOverlay() async {
    var newItem = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useSafeArea: true,
      builder: (ctx) {
        return const NewExpense();
      },
    );

    if (newItem == null) return;

    setState(() {
      _expenseItems.add(newItem);
      _isloading = false;
    });
  }

  void _loadExpenses() async {
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch expenses. Please try again later.';
        });
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<Expense> loadedExpenses = [];
      for (final item in listData.entries) {
        var category = Category.values.firstWhere(
            (element) => element.toString() == item.value['category']);
        loadedExpenses.add(
          Expense(
            id: item.key.toString(),
            title: item.value['title'],
            amount: double.parse(item.value['amount'].toString()),
            date: DateTime.parse(item.value['date']),
            category: category,
          ),
        );
      }
      setState(() {
        _expenseItems = loadedExpenses;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load expenses: $error'),
        ),
      );
    }
  }

  void _removeExpense(Expense expense) {
    var expenseIndex = _expenseItems.indexOf(expense);
    setState(() {
      _expenseItems.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenseItems.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

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
    Widget screenContent = _expenseItems.isNotEmpty
        ? ExpensesList(expenses: _expenseItems, onRemoveExpense: _removeExpense)
        : const Center(
            child: Text('No expenses found, try to add some!'),
          );

    if (_isloading) {
      screenContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      screenContent = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: Center(
        child: screenContent,
      ),
    );
  }
}
