class QuotationTrends {
  final String dateType;
  final List<String> xLabels;
  final List<QuotationTrendsData> lineChart;
  final CompareData? compareLastTwo;

  QuotationTrends({
    required this.dateType,
    required this.xLabels,
    required this.lineChart,
    required this.compareLastTwo,
  });

  factory QuotationTrends.fromJson(Map<String, dynamic> json) {
    return QuotationTrends(
      dateType: json['date_type'] as String,
      xLabels: List<String>.from(json['x_labels'] as List),
      lineChart:
          (json['line_chart'] as List).map((e) => QuotationTrendsData.fromJson(e as Map<String, dynamic>)).toList(),
      compareLastTwo: json['compare_last_two'] != null
          ? CompareData.fromJson(json['compare_last_two'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_type': dateType,
      'x_labels': xLabels,
      'line_chart': lineChart.map((e) => e.toJson()).toList(),
      'compare_last_two': compareLastTwo?.toJson(),
    };
  }
}

class QuotationTrendsData {
  final String period;
  final int count;
  final double? percentChange;
  final Map<String, int> kategoriLayanan;
  final List<int> status;
  final Map<String, int> utmCounts;

  QuotationTrendsData({
    required this.period,
    required this.count,
    this.percentChange,
    required this.kategoriLayanan,
    required this.status,
    required this.utmCounts,
  });

  factory QuotationTrendsData.fromJson(Map<String, dynamic> json) {
    return QuotationTrendsData(
      period: json['period'] as String,
      count: json['count'] as int,
      percentChange: json['percent_change'] != null ? (json['percent_change'] as num).toDouble() : null,
      kategoriLayanan: json['kategori_layanan'] != null
          ? json['kategori_layanan'] is Map
              ? Map<String, int>.from(json['kategori_layanan'] as Map)
              : {}
          : {},
      status: json['status'] is List ? List<int>.from(json['status'] as List) : [],
      utmCounts: json['utm_counts'] != null
          ? json['utm_counts'] is Map
              ? Map<String, int>.from(json['utm_counts'] as Map)
              : {}
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'count': count,
      'percent_change': percentChange,
      'kategori_layanan': kategoriLayanan,
      'status': status,
      'utm_counts': utmCounts,
    };
  }
}

class CompareData {
  final String fromPeriod;
  final String toPeriod;
  final int fromCount;
  final int toCount;
  final int change;
  final double percentChange;
  final String trend;

  CompareData({
    required this.fromPeriod,
    required this.toPeriod,
    required this.fromCount,
    required this.toCount,
    required this.change,
    required this.percentChange,
    required this.trend,
  });

  factory CompareData.fromJson(Map<String, dynamic> json) {
    return CompareData(
      fromPeriod: json['from_period'] as String,
      toPeriod: json['to_period'] as String,
      fromCount: json['from_count'] as int,
      toCount: json['to_count'] as int,
      change: json['change'] as int,
      percentChange: (json['percent_change'] as num).toDouble(),
      trend: json['trend'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_period': fromPeriod,
      'to_period': toPeriod,
      'from_count': fromCount,
      'to_count': toCount,
      'change': change,
      'percent_change': percentChange,
      'trend': trend,
    };
  }
}

const quotationTrendsExample = {
  "date_type": "monthly",
  "x_labels": ["January 2025", "February 2025", "March 2025", "April 2025", "May 2025"],
  "line_chart": [
    {
      "period": "January 2025",
      "count": 3,
      "percent_change": null,
      "kategori_layanan": {
        "sem": 0,
        "seo-content-writing": 0,
        "seo-services": 0,
        "new-service": 0,
        "press-release": 0,
        "media-partnership": 0,
        "media-buying": 0,
        "social-media-management": 0,
        "ads": 0,
        "visuwisu": 0,
        "ramadhan-2024": 0,
        "digital-marketing": 0,
        "expert-writing": 0,
        "christmas": 0,
        "seo-article": 0,
        "technical-writing": 0,
        "website-development": 0,
        "social-media-copywriting": 0
      },
      "status": [1, 0, 1, 1],
      "utm_counts": {
        "google&gdn": 0,
        "google&carousel": 0,
        "google&cpc": 0,
        "meta&gdn": 0,
        "meta&carousel": 0,
        "meta&cpc": 0,
        "googleads&gdn": 0,
        "googleads&carousel": 0,
        "googleads&cpc": 0
      }
    },
    {
      "period": "February 2025",
      "count": 3,
      "percent_change": 0,
      "kategori_layanan": {
        "sem": 1,
        "seo-content-writing": 2,
        "seo-services": 2,
        "new-service": 0,
        "press-release": 0,
        "media-partnership": 0,
        "media-buying": 0,
        "social-media-management": 0,
        "ads": 0,
        "visuwisu": 0,
        "ramadhan-2024": 0,
        "digital-marketing": 0,
        "expert-writing": 0,
        "christmas": 0,
        "seo-article": 0,
        "technical-writing": 0,
        "website-development": 0,
        "social-media-copywriting": 0
      },
      "status": [0, 0, 2, 1],
      "utm_counts": {
        "google&gdn": 0,
        "google&carousel": 0,
        "google&cpc": 0,
        "meta&gdn": 0,
        "meta&carousel": 0,
        "meta&cpc": 0,
        "googleads&gdn": 0,
        "googleads&carousel": 0,
        "googleads&cpc": 0
      }
    },
    {
      "period": "March 2025",
      "count": 758,
      "percent_change": 25166.67,
      "kategori_layanan": {
        "sem": 0,
        "seo-content-writing": 749,
        "seo-services": 748,
        "new-service": 2,
        "press-release": 0,
        "media-partnership": 0,
        "media-buying": 0,
        "social-media-management": 0,
        "ads": 0,
        "visuwisu": 0,
        "ramadhan-2024": 0,
        "digital-marketing": 0,
        "expert-writing": 0,
        "christmas": 0,
        "seo-article": 0,
        "technical-writing": 0,
        "website-development": 0,
        "social-media-copywriting": 0
      },
      "status": [9, 1, 747, 1],
      "utm_counts": {
        "google&gdn": 0,
        "google&carousel": 0,
        "google&cpc": 0,
        "meta&gdn": 0,
        "meta&carousel": 0,
        "meta&cpc": 0,
        "googleads&gdn": 0,
        "googleads&carousel": 0,
        "googleads&cpc": 0
      }
    },
    {
      "period": "April 2025",
      "count": 0,
      "percent_change": -100,
      "kategori_layanan": {
        "sem": 0,
        "seo-content-writing": 0,
        "seo-services": 0,
        "new-service": 0,
        "press-release": 0,
        "media-partnership": 0,
        "media-buying": 0,
        "social-media-management": 0,
        "ads": 0,
        "visuwisu": 0,
        "ramadhan-2024": 0,
        "digital-marketing": 0,
        "expert-writing": 0,
        "christmas": 0,
        "seo-article": 0,
        "technical-writing": 0,
        "website-development": 0,
        "social-media-copywriting": 0
      },
      "status": [0, 0, 0, 0],
      "utm_counts": {
        "google&gdn": 0,
        "google&carousel": 0,
        "google&cpc": 0,
        "meta&gdn": 0,
        "meta&carousel": 0,
        "meta&cpc": 0,
        "googleads&gdn": 0,
        "googleads&carousel": 0,
        "googleads&cpc": 0
      }
    },
    {
      "period": "May 2025",
      "count": 28,
      "percent_change": null,
      "kategori_layanan": {
        "sem": 11,
        "seo-content-writing": 7,
        "seo-services": 7,
        "new-service": 0,
        "press-release": 2,
        "media-partnership": 3,
        "media-buying": 4,
        "social-media-management": 3,
        "ads": 4,
        "visuwisu": 3,
        "ramadhan-2024": 1,
        "digital-marketing": 3,
        "expert-writing": 4,
        "christmas": 2,
        "seo-article": 3,
        "technical-writing": 1,
        "website-development": 3,
        "social-media-copywriting": 3
      },
      "status": [0, 1, 27, 0],
      "utm_counts": {
        "google&gdn": 3,
        "google&carousel": 3,
        "google&cpc": 3,
        "meta&gdn": 3,
        "meta&carousel": 3,
        "meta&cpc": 3,
        "googleads&gdn": 3,
        "googleads&carousel": 3,
        "googleads&cpc": 3
      }
    }
  ],
  "compare_last_two": {
    "from_period": "April 2025",
    "to_period": "May 2025",
    "from_count": 0,
    "to_count": 28,
    "change": 28,
    "percent_change": 100,
    "trend": "up"
  }
};
