import 'dart:convert';

import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/web_helper.dart';

import 'models/login_info_response.dart';
import '../constants.dart';
import 'package:crypto/crypto.dart';

//https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md
class WbiHelper {
  static const mixinKeyEncTab = [
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
    37,
    48,
    7,
    16,
    24,
    55,
    40,
    61,
    26,
    17,
    0,
    1,
    60,
    51,
    30,
    4,
    22,
    25,
    54,
    21,
    56,
    59,
    6,
    63,
    57,
    62,
    11,
    36,
    20,
    34,
    44,
    52
  ];
  static Future<String> getKey() async {
    if (AppStorage().settings.wbiKey != 'none' &&
        DateTime.fromMillisecondsSinceEpoch(AppStorage().settings.keyTime)
                .day ==
            DateTime.now().day) {
      return AppStorage().settings.wbiKey;
    }
    var request =
        await WebHelper().get("${Constants.apiBase}/x/web-interface/nav");
    LoginInfoResponse requestInfo = LoginInfoResponse.fromJson(request.data);
    if (requestInfo.data == null || requestInfo.data!.wbiImg == null) {
      return 'none';
    }
    var info = requestInfo.data!.wbiImg!;
    if (info.subUrl == null || info.imgUrl == null) return 'none';
    String raw = info.imgUrl!
            .substring(info.imgUrl!.lastIndexOf('/') + 1, info.imgUrl!.length)
            .split('.')[0] +
        info.subUrl!
            .substring(info.subUrl!.lastIndexOf('/') + 1, info.subUrl!.length)
            .split('.')[0];
    String key = "";
    for (int x in mixinKeyEncTab) {
      key += raw[x];
    }
    key = key.substring(0, 32);
    AppStorage().settings.wbiKey = key;
    AppStorage().settings.keyTime = DateTime.now().millisecondsSinceEpoch;
    AppStorage().saveSettings();
    return key;
  }

  static Future<Map<String, dynamic>> signParams(
      Map<String, dynamic> params) async {
    String mixinKey = await getKey();
    // calculate wts
    int wts = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    params.addAll({'wts': wts});
    // calculate w_rid
    RegExp filter = RegExp(r"[!\'\(\)*]");
    List queries = [];
    for (var key in params.keys.toList()..sort()) {
      queries.add(
          '${Uri.encodeComponent(key)}=${Uri.encodeComponent(params[key].toString().replaceAll(filter, ''))}');
    }
    String wRid =
        md5.convert(utf8.encode(queries.join('&') + mixinKey)).toString();
    params.addAll({'w_rid': wRid});
    return params;
  }
}
