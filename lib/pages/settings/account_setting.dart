import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/biliapi/bilibili_helper.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/web_helper.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '连接到 bilibili.com',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        _buildGuestCard(colorScheme),
        ListTile(
          leading: const Icon(Icons.cookie_outlined),
          title: const Text('检查登录状态'),
          onTap: () async {
            await BilibiliHelper.loginCheck().then(
              (value) {
                showDialog(
                    barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
                    useRootNavigator: false,
                    context: context,
                    builder: (context) => AlertDialog(
                          surfaceTintColor: Colors.transparent,
                          title: const Text('检查登录状态'),
                          content: Text(value ? 'success' : 'failed'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('关闭'),
                            ),
                          ],
                        ));
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('清除所有 cookies'),
          onTap: () {
            WebHelper.cookieManager.cookieJar.deleteAll();
          },
        ),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   child: const Text(
        //     '连接到 youtube.com',
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        //   ),
        // ),
      ],
    ));
  }

  Widget _buildGuestCard(ColorScheme colorScheme) {
    return SizedBox(
      height: 150,
      // TODO: 未登录时另外做一套卡片内容
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              editingController.clear();

              showDialog(
                barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  title: const Text('cookies'),
                  content: TextField(
                    autofocus: true,
                    maxLines: 8,
                    controller: editingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'SESSDATA',
                    ),
                    onSubmitted: (value) async {
                      await WebHelper.cookieManager.cookieJar.saveFromResponse(
                          Uri.parse(Constants.apiBase), [
                        Cookie('SESSDATA', value)
                      ]).then((value) => Navigator.pop(context));
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String value = editingController.text;
                        await WebHelper.cookieManager.cookieJar
                            .saveFromResponse(Uri.parse(Constants.apiBase), [
                          Cookie('SESSDATA', value)
                        ]).then((value) => Navigator.pop(context));
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //todo:limit display length
                        Text(
                          '未登录',
                          style: TextStyle(fontSize: 25),
                        ),
                        Text('使用 cookies 登录'),
                        //todo:等级栏
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
