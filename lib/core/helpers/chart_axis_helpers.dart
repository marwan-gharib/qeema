double calculateBottomInterval(int pointCount) {
  const targetLabelCount = 4;
  return (pointCount / targetLabelCount)
      .ceilToDouble()
      .clamp(1.0, pointCount.toDouble())
      .toDouble();
}
