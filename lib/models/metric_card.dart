class MetricCard {
  final String label;
  final String value;
  final String? change;
  final bool? isPositive;

  const MetricCard({
    required this.label,
    required this.value,
    this.change,
    this.isPositive,
  });
}