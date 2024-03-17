import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:playboy/backend/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '关于',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // surfaceTintColor: Colors.transparent,
          // color: cs.primaryContainer,
          child: SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.smart_display,
                    size: 80,
                    color: cs.onPrimaryContainer,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Playboy',
                        style: TextStyle(
                            fontSize: 40,
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        ' ${Constants.version}-${Constants.flag}',
                        style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              )),
        ),
        ListTile(
          leading: const Icon(
            Symbols.person_play,
            weight: 600,
          ),
          title: const Text('Playboy Project'),
          subtitle: const Text('https://github.com/Playboy-Player'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            launchUrl(Uri.https('github.com', '/Playboy-Player'));
          },
        ),
        ListTile(
          leading: const Icon(
            Symbols.code_blocks,
            weight: 600,
          ),
          title: const Text('Source Code'),
          subtitle: const Text('https://github.com/Playboy-Player/Playboy'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            launchUrl(Uri.https('github.com', '/Playboy-Player/Playboy'));
          },
        ),
        ListTile(
          leading: const Icon(
            Symbols.message,
            weight: 600,
          ),
          title: const Text('Feedback'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            launchUrl(
                Uri.https('github.com', '/Playboy-Player/Playboy/issues/new'));
          },
        )
      ],
    ));
  }
}
