import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  DownloadPageState createState() => DownloadPageState();
}

class DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          title: const Text('下载管理')),
    );
  }
}
