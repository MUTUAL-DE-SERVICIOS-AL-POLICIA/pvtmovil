part of 'notification_bloc.dart';

class NotificationState {
  final bool existNotifications;
  final List<NotificationModel>? listNotifications;
  final int? affiliateId;
  const NotificationState(
      {this.existNotifications = false,
      this.listNotifications,
      this.affiliateId});

  NotificationState copyWith({
    bool? existNotifications,
    List<NotificationModel>? listNotifications,
    int? affiliateId,
  }) =>
      NotificationState(
          existNotifications: existNotifications ?? this.existNotifications,
          listNotifications: listNotifications ?? this.listNotifications,
          affiliateId: affiliateId ?? this.affiliateId);
}
