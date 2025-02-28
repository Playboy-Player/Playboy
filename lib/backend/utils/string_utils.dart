// check if target is sub-sequence of text
bool isSubsequence(String target, String text) {
  int n = target.length, m = text.length;

  int i = 0;
  for (int j = 0; j < m && i < n; j++) {
    if (text[j].toLowerCase() == target[i].toLowerCase()) {
      i++;
    }
  }

  return i == n;
}

String unifyPath(String path, {bool endSlash = true}) {
  String result = (path).replaceAll(r'\', '/');
  if (endSlash) {
    if (!result.endsWith('/')) result += '/';
  } else {
    if (result.endsWith('/')) {
      int n = result.length;
      result = result.substring(0, n - 1);
    }
  }

  return result;
}
