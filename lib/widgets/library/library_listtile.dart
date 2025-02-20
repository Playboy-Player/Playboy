import 'package:flutter/material.dart';

class MLibraryListTile extends StatelessWidget {
  const MLibraryListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData? icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}
