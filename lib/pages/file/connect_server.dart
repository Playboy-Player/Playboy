import 'package:flutter/material.dart';

class ConnectServer extends StatefulWidget {
  const ConnectServer({super.key});

  @override
  ConnectServerState createState() => ConnectServerState();
}

class ConnectServerState extends State<ConnectServer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('连接文件服务器')),
    );
  }
}
