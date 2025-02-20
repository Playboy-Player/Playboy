import 'dart:math';

String getProgressString(Duration duration) {
  if (duration.inSeconds ~/ 3600 == 0) {
    return '${(duration.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  } else {
    return '${duration.inSeconds ~/ 3600}:${(duration.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}

String getCurrentTimeString() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

double bounded(double l, double val, double r) {
  return max(min(val, r), l);
}
