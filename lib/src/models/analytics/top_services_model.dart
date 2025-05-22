class TopServices {
  final List<TopServicesData> topServices;
  final int totalQuotation;

  TopServices({
    required this.topServices,
    required this.totalQuotation,
  });

  factory TopServices.fromJson(Map<String, dynamic> json) {
    return TopServices(
      topServices:
          (json['top_services'] as List).map((e) => TopServicesData.fromJson(e as Map<String, dynamic>)).toList(),
      totalQuotation: json['total_quotation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_services': topServices.map((e) => e.toJson()).toList(),
      'total_quotation': totalQuotation,
    };
  }
}

class TopServicesData {
  final String serviceName;
  final int quotationCount;
  final double percentage;

  TopServicesData({
    required this.serviceName,
    required this.quotationCount,
    required this.percentage,
  });

  factory TopServicesData.fromJson(Map<String, dynamic> json) {
    return TopServicesData(
      serviceName: json['service_name'] as String,
      quotationCount: json['quotation_count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'quotation_count': quotationCount,
      'percentage': percentage,
    };
  }
}

const topServicesExample = {
  "top_services": [
    {"service_name": "seo-content-writing", "quotation_count": 3, "percentage": 42.86},
    {"service_name": "sem", "quotation_count": 2, "percentage": 28.57},
    {"service_name": "press-release", "quotation_count": 1, "percentage": 14.29}
  ],
  "total_quotation": 7
};
