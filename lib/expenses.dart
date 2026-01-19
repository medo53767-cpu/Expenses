import 'package:expenses/expenses_list.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/widget/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  late Box<Expense> expenseBox;
  @override
  void initState() {
    super.initState();
    expenseBox = Hive.box<Expense>('expenses');
  }

  void _addExpenses(Expense expense) {
    expenseBox.add(expense);
  }

  void _removeExpenses(Expense expense) {
    expense.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Expense Tracker')),
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: const Icon(Icons.brightness_6),
          ),

          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                builder: (ctx) => SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.5,
                  child: NewExpense(onAddExpense: _addExpenses),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: expenseBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          final expenses = box.values.toList();

          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses yet'));
          }

          return ExpensesList(
            expenses: expenses,
            onRemoveExpense: _removeExpenses,
          );
        },
      ),
    );
  }
}
