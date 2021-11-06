import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/grocery_item.dart';

class GroceryTile extends StatelessWidget {
  GroceryTile({
    Key? key,
    required this.item,
    this.onComplete,
  })  : _textDecoration =
            item.isComplete ? TextDecoration.lineThrough : TextDecoration.none,
        super(key: key);

  final GroceryItem item;
  // onComplete handler only provided when used in the list.
  final void Function(bool?)? onComplete;
  final TextDecoration _textDecoration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 90,
          width: 6,
          color: item.color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.name}',
                    style: GoogleFonts.alef(
                      fontSize: 24,
                      decoration: _textDecoration,
                    ),
                  ),
                  const SizedBox(height: 4),
                  buildDate(),
                  const SizedBox(height: 4),
                  buildImportance(),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildQty(),
            const SizedBox(height: 16),
            buildCheckbox(),
          ],
        )
      ],
    );
  }

  Widget buildImportance() {
    switch (item.importance) {
      case Importance.high:
        return Text(
          'High',
          style: GoogleFonts.alef(
            decoration: _textDecoration,
            fontWeight: FontWeight.w900,
            color: Colors.redAccent,
          ),
        );
      case Importance.medium:
        return Text(
          'Medium',
          style: GoogleFonts.alef(
            decoration: _textDecoration,
            fontWeight: FontWeight.w800,
            color: Colors.orangeAccent,
          ),
        );
      case Importance.low:
        return Text(
          'Low',
          style: GoogleFonts.alef(
            fontWeight: FontWeight.w600,
            decoration: _textDecoration,
          ),
        );
    }
  }

  Widget buildDate() {
    final date = DateFormat('MMMM d');
    final time = DateFormat('HH:mm');

    return Text(
      '${date.format(item.date)} at ${time.format(item.date)}',
      style: GoogleFonts.alef(
        fontSize: 16,
        decoration: _textDecoration,
      ),
    );
  }

  Widget buildCheckbox() {
    return Checkbox(
      value: item.isComplete,
      onChanged: onComplete,
      // checkColor: item.color,
      // activeColor: item.color,
    );
  }

  Widget buildQty() {
    return Text(
      'Qty: ${item.qty.toString()}',
      style: GoogleFonts.lato(
        fontSize: 18,
        decoration: _textDecoration,
      ),
    );
  }
}
