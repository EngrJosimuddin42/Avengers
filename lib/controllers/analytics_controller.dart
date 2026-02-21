import 'package:get/get.dart';
import '../models/metric_card.dart';
import '../models/traffic_source.dart';

class AnalyticsController extends GetxController {
  // Tab & Range
  final selectedTab       = 'Overview'.obs;
  final selectedRange     = '7 days'.obs;
  final selectedGenderTab = 'Gender'.obs;

  final List<String> tabs       = ['Inspiration', 'Overview', 'Content', 'Viewers', 'Followers'];
  final List<String> ranges     = ['7 days', '28 days', '60 days', '365 days', 'Custom'];
  final List<String> genderTabs = ['Gender', 'Age', 'Locations'];

  // Overview 7-day Metrics
  final metricsOverview7 = <MetricCard>[
    const MetricCard(label: 'Post views',    value: '118',   change: '-20 (-14.5%)', isPositive: false),
    const MetricCard(label: 'Profile views', value: '8',     change: '+4 (+100%)',   isPositive: true),
    const MetricCard(label: 'Likes',         value: '4',     change: '0',            isPositive: true),
    const MetricCard(label: 'Comments',      value: '-87',   change: '+90 (-50.8%)', isPositive: true),
    const MetricCard(label: 'Shares',        value: '4',     change: '+4',           isPositive: true),
    const MetricCard(label: 'Est.rewards',   value: '\$0.00',change: '+\$0.00',      isPositive: true),
  ].obs;

  // Overview 365-day Metrics
  final metricsOverview365 = <MetricCard>[
    const MetricCard(label: 'Post views',    value: '1.2M'),
    const MetricCard(label: 'Profile views', value: '18K'),
    const MetricCard(label: 'Likes',         value: '94K'),
    const MetricCard(label: 'Comments',      value: '18K'),
    const MetricCard(label: 'Share',         value: '18K'),
    const MetricCard(label: 'Est.rewards',   value: '-'),
  ].obs;

  // Viewers Metrics
  final metricsViewers = <MetricCard>[
    const MetricCard(label: 'Total viewers', value: '937K'),
    const MetricCard(label: 'New viewers',   value: '18K'),
  ].obs;

  // Traffic Sources
  final trafficSources7d = <TrafficSource>[
    const TrafficSource(label: 'Search',           percentage: 69.8),
    const TrafficSource(label: 'Personal Profile', percentage: 19.4),
    const TrafficSource(label: 'Following',        percentage: 2.3),
    const TrafficSource(label: 'For You',          percentage: 2.3),
    const TrafficSource(label: 'Sound',            percentage: 0.0),
  ].obs;

  final trafficSources365d = <TrafficSource>[
    const TrafficSource(label: 'For You',          percentage: 69.8),
    const TrafficSource(label: 'Personal Profile', percentage: 2.8),
    const TrafficSource(label: 'Search',           percentage: 2.3),
  ].obs;

  // Gender Data
  final genderData = <TrafficSource>[
    const TrafficSource(label: 'Male',   percentage: 66),
    const TrafficSource(label: 'Female', percentage: 25),
    const TrafficSource(label: 'Other',  percentage: 9),
  ].obs;

  // Search Queries
  final searchQueries = <TrafficSource>[
    const TrafficSource(label: 'Yeat audio',                     percentage: 69.8),
    const TrafficSource(label: 'yeat songs',                     percentage: 19.4),
    const TrafficSource(label: 'yeat no avail slowed',           percentage: 2.3),
    const TrafficSource(label: 'yeat out the way slowed reverb', percentage: 2.3),
    const TrafficSource(label: 'Slowflowoutthraway',             percentage: 0.0),
  ].obs;

  // Editable Dates
  final startDate7d   = 'Feb 9'.obs;
  final endDate7d     = 'Feb 15'.obs;
  final startDate365d = 'Feb 16, 2025'.obs;
  final endDate365d   = 'Feb 15, 2026'.obs;

  // Computed Helpers
  bool get is7Days   => selectedRange.value == '7 days';
  bool get isViewers => selectedTab.value   == 'Viewers';

  List<MetricCard> get currentMetrics {
    if (isViewers) return metricsViewers;
    if (is7Days)   return metricsOverview7;
    return metricsOverview365;
  }

  List<TrafficSource> get currentTrafficSources {
    if (is7Days) return trafficSources7d;
    return trafficSources365d;
  }

  String get graphStartDate => is7Days ? startDate7d.value   : startDate365d.value;
  String get graphEndDate   => is7Days ? endDate7d.value     : endDate365d.value;
  String get dateRange      => '$graphStartDate – $graphEndDate';


  List<double> get graphPointsFromMetrics {
    final metrics = currentMetrics;
    if (metrics.isEmpty) return [0.0, 0.3, 0.6, 1.0];

    final values = metrics.map((m) {
      String valStr = m.value
          .replaceAll('-', '')
          .replaceAll(r'$', '')
          .trim();

      double multiplier = 1.0;
      final upper = valStr.toUpperCase();

      if (upper.endsWith('K')) {
        multiplier = 1000;
        valStr = valStr.substring(0, valStr.length - 1);
      } else if (upper.endsWith('M')) {
        multiplier = 1000000;
        valStr = valStr.substring(0, valStr.length - 1);
      }

      final val = double.tryParse(valStr) ?? 0.0;
      return val * multiplier;
    }).toList();

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0) return List.filled(metrics.length, 0.5);

    return values.map((v) => v / maxVal).toList();
  }


  void updateStartDate(String v) {
    if (is7Days) {
      startDate7d.value = v;
    } else {
      startDate365d.value = v;
    }
  }

  void updateEndDate(String v) {
    if (is7Days) {
      endDate7d.value = v;
    } else {
      endDate365d.value = v;
    }
  }
  //  Actions
  void selectTab(String tab)       => selectedTab.value = tab;
  void selectRange(String range)   => selectedRange.value = range;
  void selectGenderTab(String tab) => selectedGenderTab.value = tab;

  // Edit Gender Percentage
  void updateGenderPercentage(int index, double newPct) {
    genderData[index] = TrafficSource(
      label: genderData[index].label,
      percentage: newPct.clamp(0, 100),
    );
    genderData.refresh();
  }
  //  Edit Metric Value
  void updateMetricValue(String listTarget, int index, String newValue) {
    switch (listTarget) {
      case 'overview7':
        final old = metricsOverview7[index];
        metricsOverview7[index] = MetricCard(
          label: old.label, value: newValue,
          change: old.change, isPositive: old.isPositive,
        );
        metricsOverview7.refresh();
        break;
      case 'overview365':
        final old = metricsOverview365[index];
        metricsOverview365[index] = MetricCard(
          label: old.label, value: newValue,
          change: old.change, isPositive: old.isPositive,
        );
        metricsOverview365.refresh();
        break;
      case 'viewers':
        final old = metricsViewers[index];
        metricsViewers[index] = MetricCard(
          label: old.label, value: newValue,
          change: old.change, isPositive: old.isPositive,
        );
        metricsViewers.refresh();
        break;
    }
  }

  void updateMetricChange(String listTarget, int index, String newChange) {
    switch (listTarget) {
      case 'overview7':
        final old = metricsOverview7[index];
        metricsOverview7[index] = MetricCard(
          label: old.label, value: old.value,
          change: newChange, isPositive: old.isPositive,
        );
        metricsOverview7.refresh();
        break;
      case 'overview365':
        final old = metricsOverview365[index];
        metricsOverview365[index] = MetricCard(
          label: old.label, value: old.value,
          change: newChange, isPositive: old.isPositive,
        );
        metricsOverview365.refresh();
        break;
      case 'viewers':
        final old = metricsViewers[index];
        metricsViewers[index] = MetricCard(
          label: old.label, value: old.value,
          change: newChange, isPositive: old.isPositive,
        );
        metricsViewers.refresh();
        break;
    }
  }

  // current list target string
  String get currentListTarget {
    if (isViewers) return 'viewers';
    if (is7Days)   return 'overview7';
    return 'overview365';
  }

  //  Edit Traffic Source
  void updateTrafficSource(bool is7d, int index, String newLabel, double newPct) {
    final list = is7d ? trafficSources7d : trafficSources365d;
    list[index] = TrafficSource(label: newLabel, percentage: newPct);

    if (is7d) {
      trafficSources7d.refresh();
    } else {
      trafficSources365d.refresh();
    }
  }

  // Edit Search Query
  void updateSearchQuery(int index, String newLabel, double newPct) {
    searchQueries[index] = TrafficSource(label: newLabel, percentage: newPct);
    searchQueries.refresh();
  }
}