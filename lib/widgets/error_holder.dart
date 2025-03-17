import 'package:flutter/material.dart';

class ErrorHolder extends StatelessWidget {
  const ErrorHolder({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              const Icon(
                Icons.error,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Error: $message'),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
