part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class AddNotifications extends NotificationEvent {
  final NotificationModel notification;

  AddNotifications(this.notification);
}

class UpdateNotifications extends NotificationEvent {
  final List<NotificationModel> listNotification;

  UpdateNotifications(this.listNotification);
}
