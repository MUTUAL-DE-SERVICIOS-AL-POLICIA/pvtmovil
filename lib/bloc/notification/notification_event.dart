part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class AddNotifications extends NotificationEvent {
  final NotificationModel notification;

  AddNotifications(this.notification);
}

class UpdateNotifications extends NotificationEvent {
  final List<NotificationModel> ListNotification;

  UpdateNotifications(this.ListNotification);
}
