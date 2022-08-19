part of 'notification_bloc.dart';

class NotificationState {
  final bool existNotifications;
  final List<NotificationModel>? listNotifications;
  const NotificationState(
      {this.existNotifications = false, this.listNotifications});

  NotificationState copyWith({
    bool? existNotifications,
    List<NotificationModel>? listNotifications,
  }) =>
      NotificationState(
          existNotifications: existNotifications ?? this.existNotifications,
          listNotifications: listNotifications ?? this.listNotifications);
}
