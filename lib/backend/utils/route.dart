import 'package:flutter/material.dart';

Future<T> pushPage<T extends Object?>(BuildContext context, Widget page) async {
  return await Navigator.of(
    context,
    rootNavigator: false,
  ).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<T> pushRootPage<T extends Object?>(
    BuildContext context, Widget page) async {
  return await Navigator.of(
    context,
    rootNavigator: true,
  ).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
