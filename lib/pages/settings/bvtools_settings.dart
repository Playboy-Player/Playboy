import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/biliapi/bilibili_helper.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/web_helper.dart';
import 'package:playboy/l10n/i10n.dart';

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
              context.l10n.bvTools,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            tileColor: AppStorage().settings.enableBvTools
                ? colorScheme.primaryContainer
                : colorScheme.primaryContainer.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              child: Text(context.l10n.enable_bv_tools),
            ),
            value: AppStorage().settings.enableBvTools,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.enableBvTools = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),

          // _buildGuestCard(colorScheme),
          !AppStorage().settings.enableBvTools
              ? const SizedBox()
              : ListTile(
                  leading: const Icon(Icons.cloud_sync),
                  title: Text(context.l10n.load_cookies),
                  onTap: () {
                    editingController.clear();
                    showDialog(
                      barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
                      useRootNavigator: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        title: Text(context.l10n.cookies),
                        content: TextField(
                          autofocus: true,
                          maxLines: 8,
                          controller: editingController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'SESSDATA',
                          ),
                          onSubmitted: (value) async {
                            await WebHelper.cookieManager.cookieJar
                                .saveFromResponse(
                                    Uri.parse(BilibiliHelper.apiBase),
                                    [Cookie('SESSDATA', value)]);
                            var res = await BilibiliHelper.loginCheck();
                            setState(() {
                              AppStorage().settings.logined = res;
                            });
                            AppStorage().saveSettings();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(context.l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () async {
                              String value = editingController.text;
                              await WebHelper.cookieManager.cookieJar
                                  .saveFromResponse(
                                      Uri.parse(BilibiliHelper.apiBase),
                                      [Cookie('SESSDATA', value)]);
                              var res = await BilibiliHelper.loginCheck();
                              setState(() {
                                AppStorage().settings.logined = res;
                              });
                              AppStorage().saveSettings();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                            child: Text(context.l10n.confirm),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          !AppStorage().settings.enableBvTools
              ? const SizedBox()
              : ListTile(
                  leading: const Icon(Icons.cookie),
                  title: Text(context.l10n.refresh_cookies_status),
                  subtitle: Text(
                      '${context.l10n.current_cookies_status} ${AppStorage().settings.logined ? context.l10n.available : context.l10n.invalid}'),
                  //Text(
                  //     '当前 cookies 状态: ${AppStorage().settings.logined ? '可用' : '无效'}'),
                  onTap: () async {
                    var res = await BilibiliHelper.loginCheck();
                    setState(() {
                      AppStorage().settings.logined = res;
                    });
                    AppStorage().saveSettings();
                  },
                ),

          !AppStorage().settings.enableBvTools
              ? const SizedBox()
              : SwitchListTile(
                  title: Row(
                    children: [
                      Icon(Icons.healing),
                      SizedBox(
                        width: 12,
                      ),
                      Text(context.l10n.visitor_enable_1080p)
                    ],
                  ),
                  value: AppStorage().settings.tryLook,
                  onChanged: (bool value) {
                    setState(() {
                      AppStorage().settings.tryLook = value;
                    });
                    AppStorage().saveSettings();
                    // AppStorage().updateStatus();
                  },
                ),
          !AppStorage().settings.enableBvTools
              ? const SizedBox()
              : ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(context.l10n.clear_all_cookies),
                  onTap: () {
                    WebHelper.cookieManager.cookieJar.deleteAll();
                    setState(() {
                      AppStorage().settings.logined = false;
                    });
                    AppStorage().saveSettings();
                  },
                ),
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
