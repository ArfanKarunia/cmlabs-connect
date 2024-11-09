import 'package:hive/hive.dart';

part 'historical_lead_model.g.dart';

@HiveType(typeId: 7)
class HistoricalLeadModel {
  @HiveField(0)
  final int total;

  @HiveField(1)
  final int formUser;

  @HiveField(2)
  final int googleAds;

  @HiveField(3)
  final int metaAds;

  @HiveField(4)
  final int marketing;

  @HiveField(5)
  final List? id;

  HistoricalLeadModel({
    this.total = 0,
    this.formUser = 0,
    this.googleAds = 0,
    this.metaAds = 0,
    this.marketing = 0,
    this.id,
  });

  factory HistoricalLeadModel.fromJson(Map<String, dynamic> json) {
    // Pastikan `id` diperlakukan sebagai List<String>
    List<String> id = (json['id'] as List<dynamic>?)
            ?.map((data) => data.toString())
            .toList() ??
        [];

    return HistoricalLeadModel(
      total: json['total_data'] ?? 0,
      formUser: json['isi_form_user'] ?? 0,
      googleAds: json['google_ads'] ?? 0,
      metaAds: json['meta_ads'] ?? 0,
      marketing: json['isi_mkt_sendiri'] ?? 0,
      id: id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_data': total,
      'isi_form_user': formUser,
      'google_ads': googleAds,
      'meta_ads': metaAds,
      'isi_mkt_sendiri': marketing,
      'id': id,
    };
  }

  HistoricalLeadModel copyWith({
    int? total,
    int? formUser,
    int? googleAds,
    int? metaAds,
    int? marketing,
    List? id,
  }) {
    return HistoricalLeadModel(
      total: total ?? this.total,
      formUser: formUser ?? this.formUser,
      googleAds: googleAds ?? this.googleAds,
      metaAds: metaAds ?? this.metaAds,
      marketing: marketing ?? this.marketing,
      id: id ?? this.id,
    );
  }
}
