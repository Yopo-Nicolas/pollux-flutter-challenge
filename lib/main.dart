import 'package:flutter/material.dart';
import 'package:pollux_flutter_challenge/mocks/sample_data.dart';
import 'package:pollux_flutter_challenge/models/expense_model.dart';
import 'package:pollux_flutter_challenge/pages/add_expense_view.dart';
import 'package:pollux_flutter_challenge/pages/expense_view.dart';
import 'package:pollux_flutter_challenge/pages/expenses_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Expense> expenses = sampleExpenses;
  Expense? selectedExpense;

  @override
  Widget build(BuildContext context) {
    void handleAddExpense(Expense expense) {
      setState(() {
        expenses.add(expense);
      });
    }

    void handleEditExpense(Expense expense) {
      setState(() {
        if (selectedExpense != null) {
          int index = expenses.indexOf(selectedExpense!);
          expenses[index] = expense;
          selectedExpense = expense;
        }
      });
    }

    void handleDeleteExpense(int index) {
      setState(() {
        expenses.removeAt(index);
      });
    }

    void handleTapExpense(Expense expense) {
      setState(() {
        selectedExpense = expense;
      });
    }

    void handleOnEditExpense(Expense expense) {
      setState(() {
        int index = expenses.indexOf(expense);
        selectedExpense = expenses[index];
      });
    }

    return MaterialApp(
      title: 'Pollux Flutter Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => ExpensesView(
            expenses: expenses,
            onExpenseTap: (expense) => {
                  handleTapExpense(expense),
                  Navigator.of(context).pushNamed('/current_expense')
                },
            onExpenseDelete: handleDeleteExpense,
            onPressed: () => {
                  setState(() {
                    selectedExpense = null;
                    Navigator.of(context).pushNamed('/add_expense');
                  })
                }),
        '/add_expense': (context) => AddExpense(
              expense: selectedExpense,
              onAddExpense: handleAddExpense,
              onEditExpense: handleEditExpense,
            ),
        '/current_expense': (context) => ExpenseView(
              expense: selectedExpense!,
              onExpenseEdit: (expense) => {
                handleOnEditExpense(expense),
                Navigator.of(context).pushNamed('/add_expense')
              },
            )
      },
    );
  }
}
