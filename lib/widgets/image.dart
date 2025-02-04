import 'dart:io';

import 'package:flutter/material.dart';

class MImageProvider {
  const MImageProvider({required this.url});
  final String url;

  ImageProvider getImage() {
    return url.startsWith('http:')
        ? NetworkImage(url)
        : FileImage(File(url)) as ImageProvider;
  }
}

class MImage extends StatelessWidget {
  const MImage({super.key, required this.url});
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
