import 'package:playboy/backend/biliapi/models/login_info_response.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/biliapi/models/video_info.dart';
import 'package:playboy/backend/biliapi/models/video_info_response.dart';
import 'package:playboy/backend/biliapi/models/video_stream_response.dart';
import 'package:playboy/backend/biliapi/wbi_helper.dart';
import 'package:playboy/backend/web_helper.dart';

class BilibiliHelper {
  static Future<bool> loginCheck() async {
    var request =
        await WebHelper().get("${Constants.apiBase}/x/web-interface/nav");
    LoginInfoResponse requestInfo = LoginInfoResponse.fromJson(request.data);
    var info = requestInfo.data!;
    return info.isLogin ?? false;
  }

  static Future<VideoInfo> getVideoInfo(String bvid) async {
    var request = await WebHelper().get(
        "${Constants.apiBase}/x/web-interface/view",
        queryParameters: await WbiHelper.signParams({"bvid": bvid}));
    VideoInfoResponse requestInfo = VideoInfoResponse.fromJson(request.data);
    //todo: null safety
    var info = requestInfo.data!;
    return VideoInfo(
        coverUrl: info.pic!,
        title: info.title!,
        bvid: info.bvid!,
        description: info.desc!,
        duration: info.duration!,
        ownerHead: info.owner!.face!,
        ownerName: info.owner!.name!,
        view: info.stat!.view!,
        danmaku: info.stat!.danmaku!,
        like: info.stat!.like!,
        favourite: info.stat!.favorite!,
        coin: info.stat!.coin!,
        share: info.stat!.share!,
        hisRank: info.stat!.hisRank!,
        cid: info.cid!);
  }

  static Future<Dash> getVideoStream(String bvid, int cid) async {
    var request =
        await WebHelper().get("${Constants.apiBase}/x/player/wbi/playurl",
            queryParameters: await WbiHelper.signParams({
              "bvid": bvid,
              "cid": cid,
              "qn": 0,
              "fnval": 80,
              "fnver": 0,
              "fourk": 1,
              "try_look": 1
            }));
    VideoStreamResponse requestInfo =
        VideoStreamResponse.fromJson(request.data);
    var info = requestInfo.data!;
    var dash = info.dash!;
    return dash;
  }
}
