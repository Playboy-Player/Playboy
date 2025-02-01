import 'package:flutter/material.dart';

class MLoadingPlaceHolder extends StatelessWidget {
  const MLoadingPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        heightFactor: 10,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
