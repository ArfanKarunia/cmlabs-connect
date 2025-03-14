// enum StatusLead { newLead, followedUp, accepted, rejected, onHold}

import '../models/status_lead_model.dart';
import '../utils/color.dart';

final List<StatusLead> statusLead = [
  StatusLead(
    title: 'New',
    query: 'new',
    isEnabled: true,
    bgColor: AppColors.bgPrimary,
    color: AppColors.primary,
  ),
  StatusLead(
    title: 'Followed Up',
    query: 'followed-up',
    isEnabled: true,
    bgColor: AppColors.bgInfo,
    color: AppColors.info,
  ),
  StatusLead(
    title: 'Accepted',
    query: 'accepted',
    isEnabled: true,
    bgColor: AppColors.bgSuccess,
    color: AppColors.success,
  ),
  StatusLead(
    title: 'Rejected',
    query: 'rejected',
    isEnabled: true,
    bgColor: AppColors.bgDanger,
    color: AppColors.danger,
  ),
  StatusLead(
    title: 'On Hold',
    query: 'on-hold',
    isEnabled: true,
    bgColor: AppColors.bgPrimary,
    color: AppColors.primary,
  ),
];
