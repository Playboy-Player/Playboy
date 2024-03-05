import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: const Text(
            '关于',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Card(
          child: SizedBox(
            height: 200,
            child: Center(
                child: FlutterLogo(
              size: 200,
              style: FlutterLogoStyle.horizontal,
            )),
          ),
        ),
      ],
    ));
  }
}
