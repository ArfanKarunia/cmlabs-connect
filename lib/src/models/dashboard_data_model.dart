class DashboardData {
  final int amountNewLeads;
  final int amountLast30Days;
  final int amountAcceptedLeads;
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
