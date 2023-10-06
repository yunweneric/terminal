class ChartGroupData {
  final int x;
  final double y1;
  final double y2;

  ChartGroupData(this.x, this.y1, this.y2);

  Map<String, dynamic> toJson() {
    return {
      "x": x,
      "y1": y1,
      "y2": y2,
    };
  }
}
