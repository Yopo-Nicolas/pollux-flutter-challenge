import 'package:flutter/material.dart';
import 'package:pollux_flutter_challenge/models/expense_model.dart';

class AddExpense extends StatefulWidget {
  final Function(Expense) onAddExpense;
  final Function(Expense) onEditExpense;
  final Expense? expense;

  const AddExpense(
      {super.key,
      required this.onAddExpense,
      required this.onEditExpense,
      this.expense});

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  String _category = '';
  double _amount = 0.0;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                initialValue: widget.expense?.category,
                onSaved: (value) {
                  _category = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                initialValue: widget.expense?.amount.toString(),
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                initialValue: widget.expense?.description,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Expense newExpense = Expense(
                        description: _description,
                        category: _category,
                        amount: _amount);

                    if (widget.expense != null &&
                        newExpense != widget.expense) {
                      widget.onEditExpense(newExpense);
                    } else {
                      widget.onAddExpense(newExpense);
                    }

                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
