import 'package:get/get.dart';
import '../models/performance_models.dart';

class PerformanceController extends GetxController {
  // Tab State
  final selectedRangeTab     = 1.obs;
  final selectedCriteriaTab  = 0.obs;
  final currentMonth         = 'Feb 2026'.obs;
  final showDailyChart       = false.obs;

  final rangeTabs = ['By month', '365 days', 'Custom'];
  final criteriaTabs = ['Well-crafted', 'Engaging', 'Specialized'];

  // ─── Static Data
  final rewardsInfo = const RewardsInfo(
    rewards: '\$0.00',
    rpm: '--',
    qualifiedViews: 'less than 1,000',
    note: 'video must have at least 1,000 qualified views to be included in RPM calculation',
  );

  final List<RewardEntry> rewardEntries = const [
    RewardEntry(label: 'Standard Reward', amount: '\$0.00'),
    RewardEntry(label: 'Standard Reward', amount: '\$0.00'),
  ];

  final List<ChartBar> monthlyBars = const [
    ChartBar(label: 'Jan', value: 0.8, maxValue: 3),
    ChartBar(label: 'Mar', value: 0.0, maxValue: 3),
    ChartBar(label: 'May', value: 0.0, maxValue: 3),
    ChartBar(label: 'Jul', value: 0.0, maxValue: 3),
    ChartBar(label: 'Sep', value: 0.0, maxValue: 3),
    ChartBar(label: 'Nov', value: 0.0, maxValue: 3),
  ];

  final List<ChartBar> dailyBars = const [
    ChartBar(label: '1',  value: 0.0, maxValue: 3),
    ChartBar(label: '4',  value: 0.0, maxValue: 3),
    ChartBar(label: '7',  value: 0.0, maxValue: 3),
    ChartBar(label: '10', value: 0.0, maxValue: 3),
    ChartBar(label: '13', value: 1.8, maxValue: 3),
    ChartBar(label: '16', value: 0.0, maxValue: 3),
  ];

  final List<RewardCriteria> criteria = const [
    RewardCriteria(
      title: 'Well-crafted',
      description: 'High-quality 1 min+ videos that show an attention to detail in the creation process.',
    ),
    RewardCriteria(
      title: 'Engaging',
      description: 'High-quality 1 min+ videos that show an attention to detail in the creation process.',
    ),
    RewardCriteria(
      title: 'Specialized',
      description: 'High-quality 1 min+ videos that show an attention to detail in the creation process.',
    ),
  ];

  final List<VideoThumbnail> videos = const [
    VideoThumbnail(
      title: 'TikTok is now encouraging creator',
      creator: 'Seth',
      imagePath: 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=200',
      avatarPath: '',
    ),
    VideoThumbnail(
      title: 'TikTok is now encouraging creator',
      creator: 'Seth',
      imagePath: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=200',
      avatarPath: '',
    ),
    VideoThumbnail(
      title: 'TikTok is now encouraging creator',
      creator: 'Seth',
      imagePath: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200',
      avatarPath: '',
    ),
  ];

  //  Actions
  void selectRangeTab(int i)    => selectedRangeTab.value = i;
  void selectCriteriaTab(int i) => selectedCriteriaTab.value = i;
  void toggleChartMode()        => showDailyChart.toggle();

  void previousMonth() {
    currentMonth.value = 'Jan 2026';
  }

  void nextMonth() {
    currentMonth.value = 'Mar 2026';
  }
}