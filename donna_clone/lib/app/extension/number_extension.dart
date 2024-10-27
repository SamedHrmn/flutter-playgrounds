extension NumberFormatter on num? {
  String toShortenedFormat() {
    if (this == null) return "-";

    if (this! >= 1000000) {
      return '${(this! / 1000000).toStringAsFixed(1)}M';
    } else if (this! >= 1000) {
      return '${(this! / 1000).toStringAsFixed(1)}K';
    } else {
      return this!.toStringAsFixed(0);
    }
  }
}
