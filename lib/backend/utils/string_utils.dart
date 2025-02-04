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
