class TopPICs {
  final List<TopPICsData> topPics;
  final int totalQuotation;

  TopPICs({
    required this.topPics,
    required this.totalQuotation,
  });

  factory TopPICs.fromJson(Map<String, dynamic> json) {
    return TopPICs(
      topPics: (json['top_pics'] as List).map((e) => TopPICsData.fromJson(e as Map<String, dynamic>)).toList(),
      totalQuotation: json['total_quotation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_pics': topPics.map((e) => e.toJson()).toList(),
      'total_quotation': totalQuotation,
    };
  }
}

class TopPICsData {
  final String picName;
  final int quotationCount;
  final int newCount;
  final int followedUp;
  final int accepted;
  final int rejected;
  final int onHold;
  final double percentage;

  TopPICsData({
    required this.picName,
    required this.quotationCount,
    required this.newCount,
    required this.followedUp,
    required this.accepted,
    required this.rejected,
    required this.onHold,
    required this.percentage,
  });

  factory TopPICsData.fromJson(Map<String, dynamic> json) {
    return TopPICsData(
      picName: json['pic_name'] as String,
      quotationCount: json['quotation_count'] as int,
      newCount: json['new'] as int,
      followedUp: json['followed_up'] as int,
      accepted: json['accepted'] as int,
      rejected: json['rejected'] as int,
      onHold: json['on_hold'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pic_name': picName,
      'quotation_count': quotationCount,
      'new': newCount,
      'followed_up': followedUp,
      'accepted': accepted,
      'rejected': rejected,
      'on_hold': onHold,
      'percentage': percentage,
    };
  }
}

const topPICsExample = {
  "top_pics": [
    {
      "pic_name": "larasati",
      "quotation_count": 825,
      "new": 10,
      "followed_up": 21,
      "accepted": 784,
      "rejected": 9,
      "on_hold": 1,
      "percentage": 80.33
    },
    {
      "pic_name": "cmlabs-bizdev",
      "quotation_count": 78,
      "new": 16,
      "followed_up": 62,
      "accepted": 0,
      "rejected": 0,
      "on_hold": 0,
      "percentage": 7.59
    },
    {
      "pic_name": "aurel",
      "quotation_count": 56,
      "new": 0,
      "followed_up": 1,
      "accepted": 0,
      "rejected": 53,
      "on_hold": 2,
      "percentage": 5.45
    }
  ],
  "total_quotation": 1027
};
