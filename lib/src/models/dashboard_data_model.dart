import 'package:hive/hive.dart';

part 'dashboard_data_model.g.dart';

@HiveType(typeId: 4)
class DashboardData extends HiveObject {
  @HiveField(0)
  final int amountNewLeads;

  @HiveField(1)
  final int amountLast30Days;

  @HiveField(2)
  final int amountAcceptedLeads;

  @HiveField(3)
  final int amountFollowedupLeads;

  DashboardData({
    required this.amountNewLeads,
    required this.amountAcceptedLeads,
    required this.amountFollowedupLeads,
    required this.amountLast30Days,
  });

  factory DashboardData.fromMap(Map<String, dynamic> map) {
    return DashboardData(
      amountNewLeads: map['amount_new_leads'],
      amountAcceptedLeads: map['amount_accepted_leads'],
      amountFollowedupLeads: map['amount_followedup_leads'],
      amountLast30Days: map['last'],
    );
  }

  // Fungsi untuk convert ke Map
  Map<String, dynamic> toMap() {
    return {
      'amountNewLeads': amountNewLeads,
      'amountAcceptedLeads': amountAcceptedLeads,
      'amountFollowedupLeads': amountFollowedupLeads,
      'amountLast30Days': amountLast30Days,
    };
  }
}
