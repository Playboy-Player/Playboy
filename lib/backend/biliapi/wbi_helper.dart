import 'dart:convert';

import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/web_helper.dart';

import 'models/login_info_response.dart';
import '../constants.dart';
import 'package:crypto/crypto.dart';

class WbiHelper {
  //if the format is broken by dart format, copy this below:
  // static const mixinKeyEncTab = [
  //   46, 47, 18, 2, 53, 8, 23, 32, 15, 50, 10, 31, 58, 3, 45, 35, 27, 43, 5, 49,
  //   33, 9, 42, 19, 29, 28, 14, 39, 12, 38, 41, 13, 37, 48, 7, 16, 24, 55, 40,
  //   61, 26, 17, 0, 1, 60, 51, 30, 4, 22, 25, 54, 21, 56, 59, 6, 63, 57, 62, 11,
  //   36, 20, 34, 44, 52
  // ];
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
    //获取本地缓存
    if (AppStorage().settings.wbiKey != "error" &&
        DateTime.fromMillisecondsSinceEpoch(AppStorage().settings.keyTime)
                .day ==
            DateTime.now().day) {
      return AppStorage().settings.wbiKey;
    }
    var request =
        await WebHelper().get("${Constants.apiBase}/x/web-interface/nav");
    LoginInfoResponse requestInfo = LoginInfoResponse.fromJson(request.data);
    if (requestInfo.data == null || requestInfo.data!.wbiImg == null) {
      return "error";
    }
    var info = requestInfo.data!.wbiImg!;
    if (info.subUrl == null || info.imgUrl == null) return "error";
    //拼接并重排,取前32位
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
    //缓存新获取的值
    AppStorage().settings.wbiKey = key;
    AppStorage().settings.keyTime = DateTime.now().millisecondsSinceEpoch;
    AppStorage().saveSettings();
    return key;
  }

  static Future<Map<String, dynamic>> signParams(
      Map<String, dynamic> params) async {
    String mixinKey = await getKey();
    DateTime now = DateTime.now();
    int currTime = (now.millisecondsSinceEpoch / 1000).round();
    RegExp chrFilter = RegExp(r"[!\'\(\)*]");
    List query = [];
    Map newParams = Map.from(params)..addAll({"wts": currTime}); // 添加 wts 字段
    // 按照 key 重排参数
    List keys = newParams.keys.toList()..sort();
    for (var i in keys) {
      query.add(
          '${Uri.encodeComponent(i)}=${Uri.encodeComponent(newParams[i].toString().replaceAll(chrFilter, ''))}');
    }
    String queryStr = query.join('&');
    String wbiSign =
        md5.convert(utf8.encode(queryStr + mixinKey)).toString(); // 计算 w_rid
    Map<String, dynamic> result = params
      ..addAll({'wts': currTime.toString(), 'w_rid': wbiSign});
    return result;
  }
}
