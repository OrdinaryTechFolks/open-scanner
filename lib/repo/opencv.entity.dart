class Range {
  final int start;
  final int end;

  Range(this.start, this.end);

  int length() {
    return (end - start) + 1;
  }

  @override
  String toString() {
    return "start:$start|end:$end";
  }
}