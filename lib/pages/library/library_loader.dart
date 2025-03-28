import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/library_helper.dart';

void loadMediaLibrary(Function callback) async {
  App().mediaLibrary.addAll(
        await LibraryHelper.getMediaFromPaths(App().settings.videoPaths),
      );
  App().mediaLibraryLoaded = true;
  callback();
}
