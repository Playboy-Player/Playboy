import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:playboy/backend/biliapi/bilibili_helper.dart';
import 'package:playboy/backend/storage.dart';

class WebHelper {
  static late final Dio dio;
  static late CookieManager cookieManager;
  CancelToken _cancelToken = CancelToken();

  static final WebHelper _instance = WebHelper._internal();
  factory WebHelper() => _instance;
  WebHelper._internal() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      // headers: {'referer': 'https://www.bilibili.com'},
    );
    dio = Dio(options);
    dio.transformer = BackgroundTransformer();
    var cookiePath = '${AppStorage().dataPath}/cookies';
    cookieManager =
        CookieManager(PersistCookieJar(storage: FileStorage(cookiePath)));
    dio.interceptors.add(cookieManager);
  }

  Future<void> loadBvTools() async {
    dio.options.headers.addAll({'referer': 'https://www.bilibili.com'});
    if ((await cookieManager.cookieJar
            .loadForRequest(Uri.parse(BilibiliHelper.mainBase)))
        .isEmpty) {
      await dio.get(BilibiliHelper.mainBase);
    }
  }

  get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  post(
    String path, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  download(urlPath, savePath) async {
    Response response;
    response = await dio.download(urlPath, savePath,
        onReceiveProgress: (int count, int total) {});
    return response.data;
  }

  void cancel({required CancelToken token}) {
    _cancelToken.cancel("cancelled");
    _cancelToken = token;
  }
}
