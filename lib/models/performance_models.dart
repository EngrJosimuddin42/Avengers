
class PerformanceData {
  final String lastUpdate;
  final RewardsInfo rewardsInfo;
  final List<ChartBar> monthlyBars;
  final List<ChartBar> dailyBars;
  final List<RewardEntry> rewardEntries;
  final List<RewardCriteria> criteria;
  final List<VideoThumbnail> videos;

  const PerformanceData({
    required this.lastUpdate,
    required this.rewardsInfo,
    required this.monthlyBars,
    required this.dailyBars,
    required this.rewardEntries,
    required this.criteria,
    required this.videos,
  });
}

class RewardsInfo {
  final String rewards;
  final String rpm;
  final String qualifiedViews;
  final String note;

  const RewardsInfo({
    required this.rewards,
    required this.rpm,
    required this.qualifiedViews,
    required this.note,
  });
}

class ChartBar {
  final String label;
  final double value;
  final double maxValue;

  const ChartBar({required this.label, required this.value, required this.maxValue});

  double get normalized => maxValue == 0 ? 0 : value / maxValue;
}

class RewardEntry {
  final String label;
  final String amount;

  const RewardEntry({required this.label, required this.amount});
}

class RewardCriteria {
  final String title;
  final String description;

  const RewardCriteria({required this.title, required this.description});
}

class VideoThumbnail {
  final String title;
  final String creator;
  final String imagePath;
  final String avatarPath;

  const VideoThumbnail({
    required this.title,
    required this.creator,
    required this.imagePath,
    required this.avatarPath,
  });
}