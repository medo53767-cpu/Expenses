import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart';

const uuid = Uuid();
final dateFormatter = DateFormat.yMd();

@HiveType(typeId: 0)
enum Category {
  @HiveField(0)
  food,
  @HiveField(1)
  travel,
  @HiveField(2)
  work,
  @HiveField(3)
  leisure,
}

const categoryIcon = {
  Category.food: Icon(Icons.restaurant),
  Category.leisure: Icon(Icons.movie),
  Category.travel: Icon(Icons.flight),
  Category.work: Icon(Icons.work),
};

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.category,
  }) : id = uuid.v4();

  String formattedDate() => DateFormat.yMd().format(dateTime);
}