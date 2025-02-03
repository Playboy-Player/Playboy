import 'package:flutter/material.dart';

enum SearchType {
  playlist(id: 0, icon: Icons.apps, label: 'Playlist'),
  media(id: 1, icon: Icons.smart_display_outlined, label: 'Media'),
  ;

  const SearchType({
    required this.id,
    required this.icon,
    required this.label,
  });
  final int id;
  final IconData icon;
  final String label;
}
