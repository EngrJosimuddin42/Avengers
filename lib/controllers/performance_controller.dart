import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/performance_models.dart';

class PerformanceController extends GetxController {
  final isOverview          = true.obs;
  final selectedRangeTab    = 0.obs;
  final selectedCriteriaTab = 0.obs;
  final currentMonth        = 'Feb 2026'.obs;
  final showDailyChart      = false.obs;
  final barSelection        = ValueNotifier<int?>(null);

  // Editable app-bar date
  final lastUpdateDate = 'Feb 15'.obs;

  final rangeTabs    = ['By month', '365 days', 'Custom'];
  final criteriaTabs = ['Well-crafted', 'Engaging', 'Specialized'];

  // Month list
  final List<String> _months = const [
    'Jan 2026', 'Feb 2026', 'Mar 2026', 'Apr 2026',
    'May 2026', 'Jun 2026', 'Jul 2026', 'Aug 2026',
    'Sep 2026', 'Oct 2026', 'Nov 2026', 'Dec 2026',
  ];

  // Per-month reward entries
  final RxMap<String, List<RewardEntry>> _monthlyRewardEntries = <String, List<RewardEntry>>{
    'Jan 2026': [
      const RewardEntry(label: 'Standard Reward', amount: '\$12.40'),
      const RewardEntry(label: 'Bonus Reward',    amount: '\$3.00'),
    ],
    'Feb 2026': [
      const RewardEntry(label: 'Standard Reward', amount: '\$0.00'),
      const RewardEntry(label: 'Bonus Reward',    amount: '\$0.00'),
    ],
    'Mar 2026': [
      const RewardEntry(label: 'Standard Reward', amount: '\$8.75'),
      const RewardEntry(label: 'Bonus Reward',    amount: '\$1.50'),
    ],
  }.obs;

  // Per-month total amount
  final RxMap<String, String> _monthlyTotalAmounts = <String, String>{
    'Jan 2026': '\$15.40',
    'Feb 2026': '\$0.00',
    'Mar 2026': '\$10.25',
  }.obs;

  //  Editable date range
  final dateRangeStart = 'Feb 16, 2025'.obs;
  final dateRangeEnd   = 'Feb 15, 2026'.obs;

  //  Editable pending sync info
  final pendingAmount = '\$0.00'.obs;
  final pendingDate   = 'Feb 15'.obs;

  //  RewardsInfo fields (editable)
  final rewardsValue         = '\$0.00'.obs;
  final rewardsRpm           = '--'.obs;
  final rewardsQualifiedViews = 'less than 1,000'.obs;
  final rewardsNote          =
      'video must have at least 1,000 qualified views\nto be included in RPM calculation'.obs;

  //  Monthly chart bars
  final Map<String, List<ChartBar>> _monthlyChartBars = const {
    'Jan 2026': [
      ChartBar(label: 'Jan', value: 2.5, maxValue: 3),
      ChartBar(label: 'Mar', value: 0.0, maxValue: 3),
      ChartBar(label: 'May', value: 0.0, maxValue: 3),
      ChartBar(label: 'Jul', value: 0.0, maxValue: 3),
      ChartBar(label: 'Sep', value: 0.0, maxValue: 3),
      ChartBar(label: 'Nov', value: 0.0, maxValue: 3),
    ],
    'Feb 2026': [
      ChartBar(label: 'Jan', value: 0.8, maxValue: 3),
      ChartBar(label: 'Mar', value: 0.0, maxValue: 3),
      ChartBar(label: 'May', value: 0.0, maxValue: 3),
      ChartBar(label: 'Jul', value: 0.0, maxValue: 3),
      ChartBar(label: 'Sep', value: 0.0, maxValue: 3),
      ChartBar(label: 'Nov', value: 0.0, maxValue: 3),
    ],
    'Mar 2026': [
      ChartBar(label: 'Jan', value: 0.8, maxValue: 3),
      ChartBar(label: 'Mar', value: 1.5, maxValue: 3),
      ChartBar(label: 'May', value: 0.0, maxValue: 3),
      ChartBar(label: 'Jul', value: 0.0, maxValue: 3),
      ChartBar(label: 'Sep', value: 0.0, maxValue: 3),
      ChartBar(label: 'Nov', value: 0.0, maxValue: 3),
    ],
  };

  // Daily (365 days view) chart bars
  final Map<String, List<ChartBar>> _dailyChartBars = const {
    'Jan 2026': [
      ChartBar(label: '1',  value: 1.2, maxValue: 3),
      ChartBar(label: '4',  value: 0.5, maxValue: 3),
      ChartBar(label: '7',  value: 2.1, maxValue: 3),
      ChartBar(label: '10', value: 0.0, maxValue: 3),
      ChartBar(label: '13', value: 0.8, maxValue: 3),
      ChartBar(label: '16', value: 1.4, maxValue: 3),
    ],
    'Feb 2026': [
      ChartBar(label: '1',  value: 0.0, maxValue: 3),
      ChartBar(label: '4',  value: 0.0, maxValue: 3),
      ChartBar(label: '7',  value: 0.0, maxValue: 3),
      ChartBar(label: '10', value: 0.0, maxValue: 3),
      ChartBar(label: '13', value: 1.8, maxValue: 3),
      ChartBar(label: '16', value: 0.0, maxValue: 3),
    ],
    'Mar 2026': [
      ChartBar(label: '1',  value: 0.3, maxValue: 3),
      ChartBar(label: '4',  value: 1.0, maxValue: 3),
      ChartBar(label: '7',  value: 0.0, maxValue: 3),
      ChartBar(label: '10', value: 2.5, maxValue: 3),
      ChartBar(label: '13', value: 0.6, maxValue: 3),
      ChartBar(label: '16', value: 1.2, maxValue: 3),
    ],
  };

  // Fallbacks
  static const List<ChartBar> _defaultMonthlyBars = [
    ChartBar(label: 'Jan', value: 0.0, maxValue: 3),
    ChartBar(label: 'Mar', value: 0.0, maxValue: 3),
    ChartBar(label: 'May', value: 0.0, maxValue: 3),
    ChartBar(label: 'Jul', value: 0.0, maxValue: 3),
    ChartBar(label: 'Sep', value: 0.0, maxValue: 3),
    ChartBar(label: 'Nov', value: 0.0, maxValue: 3),
  ];

  static const List<ChartBar> _defaultDailyBars = [
    ChartBar(label: '1',  value: 0.0, maxValue: 3),
    ChartBar(label: '4',  value: 0.0, maxValue: 3),
    ChartBar(label: '7',  value: 0.0, maxValue: 3),
    ChartBar(label: '10', value: 0.0, maxValue: 3),
    ChartBar(label: '13', value: 0.0, maxValue: 3),
    ChartBar(label: '16', value: 0.0, maxValue: 3),
  ];

  static const List<RewardEntry> _defaultRewardEntries = [
    RewardEntry(label: 'Standard Reward', amount: '\$0.00'),
    RewardEntry(label: 'Bonus Reward',    amount: '\$0.00'),
  ];

  // Computed getters
  List<ChartBar> get currentBars {
    final month = currentMonth.value;
    if (selectedRangeTab.value == 1) {
      return _dailyChartBars[month] ?? _defaultDailyBars;
    }
    return _monthlyChartBars[month] ?? _defaultMonthlyBars;
  }

  List<RewardEntry> get rewardEntries =>
      _monthlyRewardEntries[currentMonth.value] ?? _defaultRewardEntries;

  String get currentTotalAmount =>
      _monthlyTotalAmounts[currentMonth.value] ?? '\$0.00';

  // Tooltip getters
  String get tooltipTitle {
    final idx = barSelection.value;
    if (idx == null || idx >= currentBars.length) return '';
    final bar  = currentBars[idx];
    final year = currentMonth.value.split(' ').last;
    if (selectedRangeTab.value == 1) {
      return '${currentMonth.value.split(' ').first} ${bar.label}';
    }
    return '${bar.label} $year';
  }

  String get tooltipAmount {
    final idx = barSelection.value;
    if (idx == null || idx >= currentBars.length) return '\$0.00';
    return '\$${currentBars[idx].value.toStringAsFixed(2)}';
  }

  // Static data
  final List<RewardCriteria> criteria = const [
    RewardCriteria(
      title: 'Well-crafted',
      description:
      'High-quality 1 min+ videos that show an attention to detail in the creation process.',
    ),
    RewardCriteria(
      title: 'Engaging',
      description:
      'High-quality 1 min+ videos that show an attention to detail in the creation process.',
    ),
    RewardCriteria(
      title: 'Specialized',
      description:
      'High-quality 1 min+ videos that show an attention to detail in the creation process.',
    ),
  ];

  final List<VideoThumbnail> videos = const [
    VideoThumbnail(title: '', creator: '', imagePath: 'assets/images/video_thumb_1.png', avatarPath: ''),
    VideoThumbnail(title: '', creator: '', imagePath: 'assets/images/video_thumb_2.png', avatarPath: ''),
    VideoThumbnail(title: '', creator: '', imagePath: 'assets/images/video_thumb_3.png', avatarPath: ''),
  ];

  // Edit Actions
  void updateTotalAmount(String value) {
    _monthlyTotalAmounts[currentMonth.value] = value;
    _monthlyTotalAmounts.refresh();
  }

  void updateRewardEntryAmount(int index, String newAmount) {
    final month   = currentMonth.value;
    final entries = List<RewardEntry>.from(
      _monthlyRewardEntries[month] ?? _defaultRewardEntries,
    );
    if (index < entries.length) {
      entries[index] = RewardEntry(
        label:  entries[index].label,
        amount: newAmount,
      );
      _monthlyRewardEntries[month] = entries;
      _monthlyRewardEntries.refresh();
    }
  }

  void updatePendingAmount(String value) => pendingAmount.value = value;
  void updatePendingDate(String value)   => pendingDate.value   = value;
  void updateDateRangeStart(String v) => dateRangeStart.value = v;
  void updateDateRangeEnd(String v)   => dateRangeEnd.value   = v;
  void updateRewardsValue(String v)          => rewardsValue.value          = v;
  void updateRewardsRpm(String v)            => rewardsRpm.value            = v;
  void updateRewardsQualifiedViews(String v) => rewardsQualifiedViews.value = v;
  void updateRewardsNote(String v)           => rewardsNote.value           = v;
  void updateLastUpdateDate(String v) => lastUpdateDate.value = v;

  // Navigation Actions
  void goToChartScreen() {
    selectedRangeTab.value = 0;
    isOverview.value = false;
  }

  void goToOverview() {
    _resetTooltip();
    isOverview.value = true;
  }

  void selectRangeTab(int i) {
    _resetTooltip();
    selectedRangeTab.value = i;
  }

  void selectCriteriaTab(int i) => selectedCriteriaTab.value = i;

  void toggleChartMode() => showDailyChart.toggle();

  void previousMonth() {
    _resetTooltip();
    final idx = _months.indexOf(currentMonth.value);
    if (idx > 0) currentMonth.value = _months[idx - 1];
  }

  void nextMonth() {
    _resetTooltip();
    final idx = _months.indexOf(currentMonth.value);
    if (idx < _months.length - 1) currentMonth.value = _months[idx + 1];
  }

  void onBarTap(int? index) {
    barSelection.value = (barSelection.value == index) ? null : index;
  }

  void _resetTooltip() => barSelection.value = null;

  @override
  void onClose() {
    barSelection.dispose();
    super.onClose();
  }
}