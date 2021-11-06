import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:uuid/uuid.dart';

enum Importance { low, medium, high }

class GroceryItem {
  final String id;
  final String name;
  final Importance importance;
  final Color color;
  final int qty;
  final DateTime date;
  final bool isComplete;

  GroceryItem({
    required this.id,
    required this.name,
    required this.importance,
    required this.color,
    required this.qty,
    required this.date,
    this.isComplete = false,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    Importance? importance,
    Color? color,
    int? qty,
    DateTime? date,
    bool? isComplete,
  }) =>
      GroceryItem(
        id: id ?? this.id,
        name: name ?? this.name,
        importance: importance ?? this.importance,
        color: color ?? this.color,
        qty: qty ?? this.qty,
        date: date ?? this.date,
        isComplete: isComplete ?? this.isComplete,
      );

  factory GroceryItem.fake({
    String? id,
    String? name,
    Importance importance: Importance.high,
    Color color: Colors.black,
    int qty: 10,
    DateTime? date,
  }) {
    id = id ?? const Uuid().v4().hashCode.toString();
    return GroceryItem(
      id: id,
      name: name ?? 'Fake Item ${id}',
      importance: importance,
      color: color,
      qty: qty,
      date: date ?? DateTime.now(),
    );
  }
}
