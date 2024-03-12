import 'package:flutter/material.dart';
import 'package:pollux_flutter_challenge/models/expense_model.dart';

class ExpenseView extends StatelessWidget {
  final Expense expense;
  final Function(Expense) onExpenseEdit;

  const ExpenseView(
      {super.key, required this.expense, required this.onExpenseEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Expense')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${expense.category}'),
                Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
                Text('Description: ${expense.description}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => onExpenseEdit(expense),
                  child: const Text('Edit'),
                ),
              ],
            )));
  }
}
