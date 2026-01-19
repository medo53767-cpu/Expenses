import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$ ',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      IconButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate = DateTime(
                            now.year - 1,
                            now.month,
                            now.day,
                          );
                          final pickedDate = await showDatePicker(
                            context: context,
                            firstDate: firstDate,
                            lastDate: DateTime.now(),
                            initialDate: now,
                          );
                          if (pickedDate == null) return;
      
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
      
                  onChanged: (newCat) {
                    if (newCat == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = newCat;
                    });
                  },
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    final enteredAmount = double.tryParse(_amountController.text);
                    final bool amountIsInvalid =
                        enteredAmount == null || enteredAmount <= 0;
      
                    if (_titleController.text.trim().isEmpty ||
                        amountIsInvalid ||
                        _selectedDate == null) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Invalid input'),
                          content: const Text(
                            'Please enter a valid title, amount and date.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      widget.onAddExpense(
                        Expense(
                          title: _titleController.text,
                          amount: enteredAmount,
                          dateTime: _selectedDate!,
                          category: _selectedCategory,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
