import 'package:flutter/widgets.dart';

extension SliverToBoxAdapterExtension on Widget {
  SliverToBoxAdapter toSliver() {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}
