import 'dart:io';

import 'package:flutter/material.dart';

class UniImageProvider {
  const UniImageProvider({required this.url});
  final String url;

  ImageProvider getImage() {
    return url.startsWith('http:')
        ? NetworkImage(url)
        : FileImage(File(url)) as ImageProvider;
  }
}

class UniImage extends StatelessWidget {
  const UniImage({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return url.startsWith('http:')
        ? Image.network(
            url,
            width: double.maxFinite,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(url),
            width: double.maxFinite,
            fit: BoxFit.cover,
          );
  }
}
