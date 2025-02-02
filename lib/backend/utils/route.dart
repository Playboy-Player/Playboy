import 'package:flutter/material.dart';

Future<T> pushPage<T extends Object?>(
  BuildContext context,
  Widget page,
) async {
  return await Navigator.of(
    context,
    rootNavigator: false,
  ).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<T> pushPageNoAnimation<T extends Object?>(
  BuildContext context,
  Widget page,
) async {
  return await Navigator.of(
    context,
    rootNavigator: false,
  ).push(
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

Future<T> pushRootPage<T extends Object?>(
  BuildContext context,
  Widget page,
) async {
  return await Navigator.of(
    context,
    rootNavigator: true,
  ).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
