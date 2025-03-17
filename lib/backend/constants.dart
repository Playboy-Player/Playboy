import 'package:flutter/material.dart';
import 'package:playboy/backend/models/contributor.dart';

const IconData appIcon = Icons.play_circle_outline;
const String appName = 'Playboy';
const String version = 'βeta 2025.2';
const String flutterVersion = '3.29.0';

List<Contributor> contributors = [
  Contributor(
    avatar: 'res/contributors/yui.jpg',
    name: 'YuiHrsw',
    url: 'https://github.com/YuiHrsw',
  ),
  Contributor(
    avatar: 'res/contributors/KernelInterrupt.jpg',
    name: 'KernelInterrupt',
    url: 'https://github.com/KernelInterrupt',
  ),
  Contributor(
    avatar: 'res/contributors/rubbrt.jpg',
    name: 'rubbrt',
    url: 'https://github.com/rubbrt',
  )
];
