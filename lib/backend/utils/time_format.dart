String getTimeStr(Duration duration) {
  return '${duration.inSeconds ~/ 3600}:${(duration.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}
