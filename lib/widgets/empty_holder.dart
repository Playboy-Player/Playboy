import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class MEmptyHolder extends StatelessWidget {
  const MEmptyHolder({super.key});

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
              const Icon(Icons.upcoming_rounded),
              const SizedBox(width: 10),
              Text('无内容'.l10n),
            ],
          ),
        ),
      ),
    );
  }
}
