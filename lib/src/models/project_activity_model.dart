import 'package:intl/intl.dart';

class ProjectActivity {
  final String? meetingTopic;
  final DateTime? meetingSchedule;
  final int? meetingStatus;
  final String? meetingType;
  final int? meetingAvailableToUser;
  final String? meetingNote;

  ProjectActivity({
    this.meetingTopic,
    this.meetingSchedule,
    this.meetingStatus,
    this.meetingType,
    this.meetingAvailableToUser,
    this.meetingNote,
  });

  factory ProjectActivity.fromJson(Map<String, dynamic> json) {
    return ProjectActivity(
      meetingTopic: json['meeting_topic'],
      meetingSchedule:
          json['meeting_schedule'] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['meeting_schedule']) : null,
      meetingStatus: json['meeting_status'] != null ? int.tryParse(json['meeting_status']) : null,
      meetingType: json['meeting_type'],
      meetingAvailableToUser: json['meeting_available_to_user'],
      meetingNote: json['meeting_note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meeting_name_or_topic': meetingTopic,
      'meeting_schedule': meetingSchedule != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(meetingSchedule!) : null,
      'meeting_status': meetingStatus.toString(),
      'meeting_type': meetingType,
      'meeting_available_to_user': meetingAvailableToUser,
      'meeting_note': meetingNote,
    };
  }

  ProjectActivity copyWith({
    String? meetingTopic,
    DateTime? meetingSchedule,
    int? meetingStatus,
    String? meetingType,
    int? meetingAvailableToUser,
    String? meetingNote,
  }) {
    return ProjectActivity(
      meetingTopic: meetingTopic ?? this.meetingTopic,
      meetingSchedule: meetingSchedule ?? this.meetingSchedule,
      meetingStatus: meetingStatus ?? this.meetingStatus,
      meetingType: meetingType ?? this.meetingType,
      meetingAvailableToUser: meetingAvailableToUser ?? this.meetingAvailableToUser,
      meetingNote: meetingNote ?? this.meetingNote,
    );
  }
}
