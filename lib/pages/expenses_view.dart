import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pollux_flutter_challenge/models/expense_model.dart';

class ExpensesView extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onExpenseTap;
  final Function(int) onExpenseDelete;
  final VoidCallback onPressed;

  const ExpensesView(
      {super.key,
      required this.expenses,
      required this.onExpenseTap,
      required this.onExpenseDelete,
      required this.onPressed});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  @override
  Widget build(BuildContext context) {
    const SizedBox sizedBox = SizedBox(
      height: 20,
    );

    List<charts.Series<Expense, String>> series = [
      charts.Series(
        id: "Expenses",
        data: widget.expenses,
        domainFn: (Expense expense, _) => expense.category,
        measureFn: (Expense expense, _) => expense.amount,
        colorFn: (Expense expense, _) =>
            charts.ColorUtil.fromDartColor(Color(Random().nextInt(0xffffffff))),
        labelAccessorFn: (Expense expense, _) =>
            '\$${expense.amount.toStringAsFixed(2)}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: widget.expenses.isEmpty
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_expenses.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    sizedBox,
                    const Text(
                      'No expenses found.',
                      style: TextStyle(fontSize: 20),
                    ),
                    sizedBox,
                    ElevatedButton(
                      onPressed: widget.onPressed,
                      child: const Text('Add Expense'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width - 100,
                  height: 300,
                  padding: const EdgeInsets.all(10.0),
                  child: charts.PieChart(series, animate: true),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = widget.expenses[index];
                      return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            final listItem = widget.expenses[index];
                            if (direction == DismissDirection.startToEnd) {
                              setState(() {
                                widget.expenses.removeAt(index);
                              });
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${listItem.category} dismissed'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      widget.expenses.insert(index, listItem);
                                    });
                                  },
                                ),
                              ),
                            );

                            if (widget.expenses[index] == listItem) {
                              return false;
                            }

                            return true;
                          },
                          onDismissed: (direction) {
                            setState(() {
                              widget.onExpenseDelete(index);
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              widget.onExpenseTap(expense);
                            },
                            child: ListTile(
                              title: Text(expense.description),
                              subtitle: Text(
                                  '\$${expense.amount.toStringAsFixed(2)}'),
                            ),
                          ));
                    },
                  ),
                )
              ],
            ),
      bottomNavigationBar: widget.expenses.isNotEmpty
          ? FloatingActionButton(
              onPressed: widget.onPressed,
              child: const Text('Add Expense'),
            )
          : null,
    );
  }
}
