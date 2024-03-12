import 'dart:math';
import "package:collection/collection.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

    Map<String, List<Expense>> groupedExpenses =
        groupBy(widget.expenses, (Expense expense) => expense.category);

    late List<Expense> expensesByCategory = [];

    groupedExpenses.forEach((key, value) {
      double categoryValue = 0;
      for (var element in value) {
        categoryValue += element.amount;
      }
      Expense newExpense = Expense(
          description: 'Grouped $key', category: key, amount: categoryValue);
      expensesByCategory.add(newExpense);
    });

    List<PieChartSectionData> series = [
      ...expensesByCategory.map((expense) => PieChartSectionData(
          color: Color(Random().nextInt(0xffffffff)),
          value: expense.amount,
          title: '${expense.category} \n \$${expense.amount}',
          titleStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))
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
                  child: PieChart(PieChartData(
                      sections: series,
                      centerSpaceRadius: double.infinity,
                      sectionsSpace: 10)),
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
                                  content:
                                      Text('${listItem.category} dismissed'),
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
                      }),
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
