import 'package:flutter/material.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.l10n.about,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(80),
              ),
            ),
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.smart_display,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      Text(
                        'Playboy',
                        style: TextStyle(
                            fontSize: 40,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        ' ${Constants.version} ${Constants.flag}',
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.l10n.contributors,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 100,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 18);
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Tooltip(
                  message: Constants.maintainers[index].url,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (Constants.maintainers[index].url == '') {
                        return;
                      }
                      launchUrl(Uri.parse(Constants.maintainers[index].url));
                    },
                    child: SizedBox(
                      height: 80,
                      width: 60,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              Constants.maintainers[index].avatar,
                            ),
                            radius: 28,
                          ),
                          Text(
                            Constants.maintainers[index].name,
                            style: const TextStyle(
                              // color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: Constants.maintainers.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.l10n.support,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.data_object,
            ),
            title: Text(context.l10n.projectWebsite),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              launchUrl(Uri.https('github.com', '/Playboy-Player/Playboy'));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.feedback_outlined,
            ),
            title: Text(context.l10n.feedback),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              launchUrl(
                Uri.https('github.com', '/Playboy-Player/Playboy/issues/new'),
              );
            },
          )
        ],
      ),
    );
  }
}
