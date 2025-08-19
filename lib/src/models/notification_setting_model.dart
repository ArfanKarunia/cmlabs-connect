class NotificationSetting {
  int? id;
  int? userId;
  bool? newQuotationInboxPush;
  bool? followUpReminderPush;
  bool? newQuotationInboxEmail;
  bool? followUpReminderEmail;
  List<String>? quietModeDays;
  String? quietModeStartTime;
  String? quietModeEndTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? newCaseStudiesInboxPush;
  bool? newContactUsInboxPush;
  bool? newFaqInboxInboxPush;
  bool? newCaseStudiesInboxEmail;
  bool? newContactUsInboxEmail;
  bool? newFaqInboxInboxEmail;

  NotificationSetting({
    this.id,
    this.userId,
    this.newQuotationInboxPush,
    this.followUpReminderPush,
    this.newQuotationInboxEmail,
    this.followUpReminderEmail,
    this.quietModeDays,
    this.quietModeStartTime,
    this.quietModeEndTime,
    this.createdAt,
    this.updatedAt,
    this.newCaseStudiesInboxPush,
    this.newContactUsInboxPush,
    this.newFaqInboxInboxPush,
    this.newCaseStudiesInboxEmail,
    this.newContactUsInboxEmail,
    this.newFaqInboxInboxEmail,
  });

  NotificationSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    newQuotationInboxPush = json['new_quotation_inbox_push'];
    followUpReminderPush = json['follow_up_reminder_push'];
    newQuotationInboxEmail = json['new_quotation_inbox_email'];
    followUpReminderEmail = json['follow_up_reminder_email'];
    quietModeDays = json['quiet_mode_days'] != null ? json['quiet_mode_days'].cast<String>() : [];
    quietModeStartTime = json['quiet_mode_start_time'];
    quietModeEndTime = json['quiet_mode_end_time'];
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now();
    updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now();
    newCaseStudiesInboxPush = json['new_case_studies_inbox_push'];
    newContactUsInboxPush = json['new_contact_us_inbox_push'];
    newFaqInboxInboxPush = json['new_faq_inbox_inbox_push'];
    newCaseStudiesInboxEmail = json['new_case_studies_inbox_email'];
    newContactUsInboxEmail = json['new_contact_us_inbox_email'];
    newFaqInboxInboxEmail = json['new_faq_inbox_inbox_email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'new_quotation_inbox_push': newQuotationInboxPush,
      'follow_up_reminder_push': followUpReminderPush,
      'new_quotation_inbox_email': newQuotationInboxEmail,
      'follow_up_reminder_email': followUpReminderEmail,
      'quiet_mode_days': quietModeDays,
      'quiet_mode_start_time': quietModeStartTime,
      'quiet_mode_end_time': quietModeEndTime,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'new_case_studies_inbox_push': newCaseStudiesInboxPush,
      'new_contact_us_inbox_push': newContactUsInboxPush,
      'new_faq_inbox_inbox_push': newFaqInboxInboxPush,
      'new_case_studies_inbox_email': newCaseStudiesInboxEmail,
      'new_contact_us_inbox_email': newContactUsInboxEmail,
      'new_faq_inbox_inbox_email': newFaqInboxInboxEmail,
    };
  }
}
