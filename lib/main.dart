import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExpenseTrackerPage(),
    );
  }
}

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});
}

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  _ExpenseTrackerPageState createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Expense> _expenses = [];
  double _totalAmount = 0.0;
  int? _editingIndex;

  void _addOrEditExpense() {
    final String description = _descriptionController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (description.isNotEmpty && amount != null) {
      setState(() {
        if (_editingIndex == null) {
          // Adding a new expense
          _expenses.add(Expense(description: description, amount: amount));
          _totalAmount += amount;
        } else {
          // Editing an existing expense
          _totalAmount -= _expenses[_editingIndex!].amount;
          _totalAmount += amount;
          _expenses[_editingIndex!] =
              Expense(description: description, amount: amount);
          _editingIndex = null; // Reset editing index after saving changes
        }
        _descriptionController.clear();
        _amountController.clear();
      });
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      _totalAmount -= _expenses[index].amount;
      _expenses.removeAt(index);
    });
  }

  void _editExpense(int index) {
    setState(() {
      _editingIndex = index;
      _descriptionController.text = _expenses[index].description;
      _amountController.text = _expenses[index].amount.toString();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF283618),
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrEditExpense,
              child:
                  Text(_editingIndex == null ? 'Add Expense' : 'Save Changes'),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Spent: \$${_totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _expenses.isEmpty
                  ? const Center(
                      child: Text(
                        'No expenses added yet!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return Card(
                          color: const Color(0xFF3D405B),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          child: ListTile(
                            title: Text(
                              expense.description,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  onPressed: () => _editExpense(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () => _deleteExpense(index),
                                ),
                                Text(
                                  '\$${expense.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
