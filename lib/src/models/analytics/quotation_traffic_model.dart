class QuotationTraffic {
  final String chartType;
  final String dateType;
  final String xLabel;
  final String yLabel;
  final List<String> labels;
  final List<QuotationTrafficData> data;
  final int totalQuotation;

  QuotationTraffic({
    required this.chartType,
    required this.dateType,
    required this.xLabel,
    required this.yLabel,
    required this.labels,
    required this.data,
    required this.totalQuotation,
  });

  factory QuotationTraffic.fromJson(Map<String, dynamic> json) {
    return QuotationTraffic(
      chartType: json['chart_type'] as String,
      dateType: json['date_type'] as String,
      xLabel: json['x_label'] as String,
      yLabel: json['y_label'] as String,
      labels: List<String>.from(json['labels'] as List),
      data: (json['data'] as List).map((e) => QuotationTrafficData.fromJson(e as Map<String, dynamic>)).toList(),
      totalQuotation: json['total_quotation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chart_type': chartType,
      'date_type': dateType,
      'x_label': xLabel,
      'y_label': yLabel,
      'labels': labels,
      'data': data.map((e) => e.toJson()).toList(),
      'total_quotation': totalQuotation,
    };
  }
}

class QuotationTrafficData {
  final int total;
  final Map<String, int> perSource;
  final Map<String, int> statusSummary;
  final Map<String, int> categorySummary;

  QuotationTrafficData({
    required this.total,
    required this.perSource,
    required this.statusSummary,
    required this.categorySummary,
  });

  factory QuotationTrafficData.fromJson(Map<String, dynamic> json) {
    return QuotationTrafficData(
      total: json['total'] as int,
      perSource: Map<String, int>.from(json['per_source'] as Map),
      statusSummary: Map<String, int>.from(json['status_summary'] as Map),
      categorySummary: Map<String, int>.from(json['category_summary'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_source': perSource,
      'status_summary': statusSummary,
      'category_summary': categorySummary,
    };
  }
}

const quotationTrafficExample = {
  "chart_type": "bar",
  "date_type": "daily",
  "x_label": "Hari, Tanggal",
  "y_label": "Jumlah Quotation",
  "labels": [
    "Thursday, 2023-08-10",
    "Thursday, 2023-08-03",
    "Friday, 2023-08-04",
    "Tuesday, 2023-08-01",
    "Wednesday, 2023-08-02",
    "Saturday, 2023-08-05",
    "Sunday, 2023-08-06",
    "Monday, 2023-08-07",
    "Tuesday, 2023-08-08",
    "Wednesday, 2023-08-09",
    "Friday, 2023-08-11",
    "Saturday, 2023-08-12",
    "Sunday, 2023-08-13",
    "Monday, 2023-08-14",
    "Tuesday, 2023-08-15"
  ],
  "data": [
    {
      "total": 11,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 2,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 1,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 3,
        "others": 5
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 11, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 7,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 6,
        "others": 1
      },
      "status_summary": {"new": 0, "followed_up": 1, "accepted": 0, "rejected": 6, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 5,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 5,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 2, "accepted": 0, "rejected": 3, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 2,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 2,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 2, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    },
    {
      "total": 0,
      "per_source": {
        "google & gdn": 0,
        "google & carousel": 0,
        "google & cpc": 0,
        "meta & gdn": 0,
        "meta & carousel": 0,
        "meta & cpc": 0,
        "google ads & gdn": 0,
        "google ads & carousel": 0,
        "google ads & cpc": 0,
        "direct": 0,
        "others": 0
      },
      "status_summary": {"new": 0, "followed_up": 0, "accepted": 0, "rejected": 0, "on_hold": 0},
      "category_summary": {
        "seo content writing": 0,
        "seo services": 0,
        "sem": 0,
        "social media management": 0,
        "digital marketing": 0
      }
    }
  ],
  "total_quotation": 25
};
