import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPath(String path) {
  var bytes = utf8.encode(path);

  var digest = md5.convert(bytes);

  return digest.toString();
}
