import 'package:flutter/material.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
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
              '关于'.l10n,
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
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(80),
              //   topRight: Radius.circular(30),
              //   bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(80),
              // ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Constants.appIcon,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      Text(
                        Constants.appName,
                        style: TextStyle(
                          fontSize: 40,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' ${Constants.version}',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   child: Text(
          //     '贡献者',
          //     style: TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.w500,
          //       color: Theme.of(context).colorScheme.secondary,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 30),
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
                  message: Constants.contributors[index].url,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (Constants.contributors[index].url == '') {
                        return;
                      }
                      launchUrl(Uri.parse(Constants.contributors[index].url));
                    },
                    child: SizedBox(
                      height: 80,
                      width: 60,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              Constants.contributors[index].avatar,
                            ),
                            radius: 28,
                          ),
                          Text(
                            Constants.contributors[index].name,
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
              itemCount: Constants.contributors.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '帮助'.l10n,
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
            title: Text('项目主页'.l10n),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              launchUrl(Uri.https('github.com', '/Playboy-Player/Playboy'));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.feedback_outlined,
            ),
            title: Text('反馈'.l10n),
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
