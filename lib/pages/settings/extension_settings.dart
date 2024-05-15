// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:playboy/backend/biliapi/bilibili_helper.dart';
// import 'package:playboy/backend/constants.dart';
// import 'package:playboy/backend/storage.dart';
// import 'package:playboy/backend/web_helper.dart';

class ExtensionSettings extends StatefulWidget {
  const ExtensionSettings({super.key});

  @override
  State<StatefulWidget> createState() => _ExtensionSettingsState();
}

class _ExtensionSettingsState extends State<ExtensionSettings> {
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
              'BV Tools',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
          ),
          // _buildGuestCard(colorScheme),
          // ListTile(
          //   leading: const Icon(Icons.cookie_outlined),
          //   title: const Text('刷新 cookies 状态'),
          //   onTap: () async {
          //     var res = await BilibiliHelper.loginCheck();
          //     setState(() {
          //       AppStorage().settings.logined = res;
          //     });
          //     AppStorage().saveSettings();
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.delete_outline),
          //   title: const Text('清除所有 cookies'),
          //   onTap: () {
          //     WebHelper.cookieManager.cookieJar.deleteAll();
          //     setState(() {
          //       AppStorage().settings.logined = false;
          //     });
          //     AppStorage().saveSettings();
          //   },
          // ),
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   child: const Text(
          //     '连接到 youtube.com',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildGuestCard(ColorScheme colorScheme) {
  //   return SizedBox(
  //     height: 120,
  //     child: AppStorage().settings.logined
  //         ? Card(
  //             elevation: 0,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //             color: colorScheme.secondaryContainer.withOpacity(0.4),
  //             child: InkWell(
  //               borderRadius: BorderRadius.circular(20),
  //               onTap: () {
  //                 WebHelper.cookieManager.cookieJar.deleteAll();
  //                 setState(() {
  //                   AppStorage().settings.logined = false;
  //                 });
  //                 AppStorage().saveSettings();
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Row(
  //                   children: [
  //                     const Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 10),
  //                       child: Icon(
  //                         Icons.check_circle_outline,
  //                         size: 50,
  //                       ),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.all(15),
  //                       child: const Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             '已连接',
  //                             style: TextStyle(fontSize: 20),
  //                           ),
  //                           Text('点击清除 cookies'),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ))
  //         : Card(
  //             elevation: 0,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //             color: colorScheme.secondaryContainer.withOpacity(0.4),
  //             child: InkWell(
  //               borderRadius: BorderRadius.circular(20),
  //               onTap: () {
  //                 editingController.clear();

  //                 showDialog(
  //                   barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
  //                   useRootNavigator: false,
  //                   context: context,
  //                   builder: (BuildContext context) => AlertDialog(
  //                     surfaceTintColor: Colors.transparent,
  //                     title: const Text('cookies'),
  //                     content: TextField(
  //                       autofocus: true,
  //                       maxLines: 8,
  //                       controller: editingController,
  //                       decoration: const InputDecoration(
  //                         border: OutlineInputBorder(),
  //                         labelText: 'SESSDATA',
  //                       ),
  //                       onSubmitted: (value) async {
  //                         await WebHelper.cookieManager.cookieJar
  //                             .saveFromResponse(Uri.parse(Constants.apiBase),
  //                                 [Cookie('SESSDATA', value)]);
  //                         var res = await BilibiliHelper.loginCheck();
  //                         setState(() {
  //                           AppStorage().settings.logined = res;
  //                         });
  //                         AppStorage().saveSettings();
  //                         if (!context.mounted) return;
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                     actions: <Widget>[
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         child: const Text('取消'),
  //                       ),
  //                       TextButton(
  //                         onPressed: () async {
  //                           String value = editingController.text;
  //                           await WebHelper.cookieManager.cookieJar
  //                               .saveFromResponse(Uri.parse(Constants.apiBase),
  //                                   [Cookie('SESSDATA', value)]);
  //                           var res = await BilibiliHelper.loginCheck();
  //                           setState(() {
  //                             AppStorage().settings.logined = res;
  //                           });
  //                           AppStorage().saveSettings();
  //                           if (!context.mounted) return;
  //                           Navigator.pop(context);
  //                         },
  //                         child: const Text('确定'),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Row(
  //                   children: [
  //                     const Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 10),
  //                       child: Icon(
  //                         Icons.person,
  //                         size: 50,
  //                       ),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.all(15),
  //                       child: const Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             '未连接',
  //                             style: TextStyle(fontSize: 20),
  //                           ),
  //                           Text('点击加载 cookies'),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )),
  //   );
  // }
}
