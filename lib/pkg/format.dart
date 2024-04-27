extension NavigatorStateExts on double {
  String toStringAsFixedOpt(int fractionDigits) {
    return toStringAsFixed(truncateToDouble() == this ? 0 : fractionDigits);
  }
}
