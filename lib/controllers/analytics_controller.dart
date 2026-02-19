import 'dart:math' as math;

import 'package:get/get.dart';
import '../models/metric_card.dart';
import '../models/traffic_source.dart';

class AnalyticsController extends GetxController {
  // ── Tab & Range ──────────────────────────────
  final selectedTab       = 'Overview'.obs;
  final selectedRange     = '7 days'.obs;
  final selectedGenderTab = 'Gender'.obs;

  final List<String> tabs       = ['Inspiration', 'Overview', 'Content', 'Viewers', 'Followers'];
  final List<String> ranges     = ['7 days', '28 days', '60 days', '365 days', 'Custom'];
  final List<String> genderTabs = ['Gender', 'Age', 'Locations'];

  // ── Overview 7-day Metrics ────────────────────
  final metricsOverview7 = <MetricCard>[
    const MetricCard(label: 'Post views',    value: '118',   change: '-20 (-14.5%)', isPositive: false),
    const MetricCard(label: 'Profile views', value: '8',     change: '+4 (+100%)',   isPositive: true),
    const MetricCard(label: 'Likes',         value: '4',     change: '0',            isPositive: true),
    const MetricCard(label: 'Comments',      value: '-87',   change: '+90 (-50.8%)', isPositive: true),
    const MetricCard(label: 'Shares',        value: '4',     change: '+4',           isPositive: true),
    const MetricCard(label: 'Est.rewards',   value: '\$0.00',change: '+\$0.00',      isPositive: true),
  ].obs;

  // ── Overview 365-day Metrics ──────────────────
  final metricsOverview365 = <MetricCard>[
    const MetricCard(label: 'Post views',    value: '1.2M'),
    const MetricCard(label: 'Profile views', value: '18K'),
    const MetricCard(label: 'Likes',         value: '94K'),
    const MetricCard(label: 'Comments',      value: '18K'),
    const MetricCard(label: 'Share',         value: '18K'),
    const MetricCard(label: 'Est.rewards',   value: '-'),
  ].obs;

  // ── Viewers Metrics ───────────────────────────
  final metricsViewers = <MetricCard>[
    const MetricCard(label: 'Total viewers', value: '937K'),
    const MetricCard(label: 'New viewers',   value: '18K'),
  ].obs;

  //  Graph Points
  final graphPoints7d = <double>[0.33, 0.2, 0.5, 0.75, 0.9, 0.6, 0.55].obs;
  final graphPoints365d = <double>[
    ...List.generate(20, (index) => 0.05 + (math.Random().nextDouble() * 0.05)),
    0.95,
    0.1,
    ...List.generate(30, (index) => 0.1 + (math.Random().nextDouble() * 0.1)),
    ...List.generate(20, (index) => 0.2 + (math.Random().nextDouble() * 0.3)),
    ...List.generate(30, (index) => 0.05 + (math.Random().nextDouble() * 0.02)),
  ].obs;

  // ── Traffic Sources 7d
  final trafficSources7d = <TrafficSource>[
    const TrafficSource(label: 'Search',          percentage: 69.8),
    const TrafficSource(label: 'Personal Profile',percentage: 19.4),
    const TrafficSource(label: 'Following',       percentage: 2.3),
    const TrafficSource(label: 'For You',         percentage: 2.3),
    const TrafficSource(label: 'Sound',           percentage: 0.0),
  ].obs;

  // ── Traffic Sources 365d
  final trafficSources365d = <TrafficSource>[
    const TrafficSource(label: 'For You',          percentage: 69.8),
    const TrafficSource(label: 'Personal Profile', percentage: 2.8),
    const TrafficSource(label: 'Search',           percentage: 2.3),
  ].obs;

  // ── Gender Data ───────────────────────────────
  final genderData = <TrafficSource>[
    const TrafficSource(label: 'Male',   percentage: 66),
    const TrafficSource(label: 'Female', percentage: 25),
    const TrafficSource(label: 'Other',  percentage: 9),
  ].obs;

  // ── Search Queries (শুধু 7 days এ দেখাবে) ────
  final searchQueries = <TrafficSource>[
    const TrafficSource(label: 'Yeat audio',                      percentage: 69.8),
    const TrafficSource(label: 'yeat songs',                      percentage: 19.4),
    const TrafficSource(label: 'yeat no avail slowed',            percentage: 2.3),
    const TrafficSource(label: 'yeat out the way slowed reverb',  percentage: 2.3),
    const TrafficSource(label: 'Slowflowoutthraway',              percentage: 0.0),
  ].obs;

  // ── Computed Helpers ──────────────────────────
  bool get is7Days   => selectedRange.value == '7 days';
  bool get isViewers => selectedTab.value == 'Viewers';

  List<MetricCard> get currentMetrics {
    if (isViewers) return metricsViewers;
    if (is7Days)   return metricsOverview7;
    return metricsOverview365;
  }

  List<double> get currentGraphPoints {
    if (is7Days) return graphPoints7d;
    return graphPoints365d;
  }

  List<TrafficSource> get currentTrafficSources {
    if (is7Days) return trafficSources7d;
    return trafficSources365d;
  }

  String get graphStartDate => is7Days ? 'Feb 9'         : 'Feb 16, 2025';
  String get graphEndDate   => is7Days ? 'Feb 15'        : 'Feb 15, 2026';
  String get dateRange      => is7Days ? 'Feb 9 – Feb 15': 'Feb 16, 2025 – Feb 15, 2026';

  // ── Actions ───────────────────────────────────
  void selectTab(String tab)       => selectedTab.value = tab;
  void selectRange(String range)   => selectedRange.value = range;
  void selectGenderTab(String tab) => selectedGenderTab.value = tab;
}