String getProgressString(Duration duration) {
  return '${duration.inSeconds ~/ 3600}:${(duration.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}

String getCurrentTimeString() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}
