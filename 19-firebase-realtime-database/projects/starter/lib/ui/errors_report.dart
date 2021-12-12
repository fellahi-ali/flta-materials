import 'package:flutter/material.dart';

class ErrorReport extends StatelessWidget {
  const ErrorReport({
    required this.error,
    Key? key,
  }) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
