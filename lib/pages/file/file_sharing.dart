import 'package:flutter/material.dart';

class FileSharing extends StatefulWidget {
  const FileSharing({super.key});

  @override
  FileSharingState createState() => FileSharingState();
}

class FileSharingState extends State<FileSharing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('局域网共享')),
    );
  }
}
