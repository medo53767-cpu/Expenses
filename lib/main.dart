import 'package:expenses/expenses.dart';
import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light, 
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: const CardThemeData(a
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, 
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      home: Expenses(toggleTheme: _toggleTheme),
    );
  }
}