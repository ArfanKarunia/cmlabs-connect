import 'project_activity_model.dart';
import 'project_history_model.dart';
import 'client_pic_model.dart';

class InboxEditForm {
  final String? pic;
  final int? priority;
  final int? status;
  final List<String>? type;
  final List<ClientPic>? picClientSide;
  final String? remarks;
  final String? additionalNotes;
  final List<ProjectActivity>? projectActivity;
  final UrlTracking? urlTracking;
  final List<ProjectHistory>? projectHistory;

  InboxEditForm({
    this.pic,
    this.priority,
    this.status,
    this.type,
    this.picClientSide,
    this.remarks,
    this.additionalNotes,
    this.projectActivity,
    this.urlTracking,
    this.projectHistory,
  });

  factory InboxEditForm.fromJson(Map<String, dynamic> json) {
    final List<ClientPic> picClientSide =
        (json['pic_client_side'] as List<dynamic>?)?.map((contact) => ClientPic.fromJson(contact)).toList() ?? [];
    final List<ProjectActivity> projectActivity =
        (json['activity'] as List<dynamic>?)?.map((activity) => ProjectActivity.fromJson(activity)).toList() ?? [];
    final List<ProjectHistory> projectHistory =
        (json['project_activity'] as List<dynamic>?)?.map((history) => ProjectHistory.fromJson(history)).toList() ?? [];

    return InboxEditForm(
      pic: json['pic'],
      priority: json['priority'],
      status: json['status'],
      type: json['type'] == null ? [] : List<String>.from(json['type']),
      picClientSide: picClientSide,
      remarks: json['remarks'],
      additionalNotes: json['additional_notes'],
      projectActivity: projectActivity,
      urlTracking: json['url_tracking'] == null ? null : UrlTracking.fromJson(json['url_tracking']),
      projectHistory: projectHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pic": pic,
      "priority": priority,
      "status": status,
      "type": type == null ? [] : List<dynamic>.from(type!.map((x) => x)),
      "pic_client_side": picClientSide == null ? [] : List<dynamic>.from(picClientSide!.map((x) => x.toJson())),
      "remarks": remarks,
      "additional_notes": additionalNotes,
      "activity": projectActivity == null ? [] : List<dynamic>.from(projectActivity!.map((x) => x.toJson())),
      "url_tracking": urlTracking?.toJson(),
      "project_activity": projectHistory == null ? [] : List<dynamic>.from(projectHistory!.map((x) => x.toJson())),
    };
  }
}

class UrlTracking {
  final String? url;
  final String? password;
  final DateTime? validity;
  final DateTime? expiredAt;

  UrlTracking({
    this.url,
    this.password,
    this.validity,
    this.expiredAt,
  });

  factory UrlTracking.fromJson(Map<String, dynamic> json) {
    return UrlTracking(
      url: json["URL"],
      password: json["password"],
      validity: json["validity"] == null ? null : DateTime.parse(json["validity"]),
      expiredAt: json["Expired_at"] == null ? null : DateTime.parse(json["Expired_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "URL": url,
      "password": password,
      "validity": validity?.toIso8601String(),
      "Expired_at": expiredAt?.toIso8601String(),
    };
  }
}
