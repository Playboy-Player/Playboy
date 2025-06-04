import 'package:flutter/material.dart';

class SettingsStringValue extends StatelessWidget {
  SettingsStringValue({
    super.key,
    required this.hintText,
    this.onSubmitted,
  });

  final TextEditingController controller = TextEditingController();
  final String hintText;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // width: 150,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.4),
        ),
        child: TextField(
          // textAlign: TextAlign.center,
          controller: controller,
          maxLines: 1,
          decoration: InputDecoration.collapsed(
            hintText: hintText,
          ),
          onSubmitted: (value) {
            controller.clear();
            onSubmitted?.call(value);
          },
        ),
      ),
    );
  }
}
