import 'package:bloc/bloc.dart';
import 'package:muserpol_pvt/database/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<AddNotifications>((event, emit) {
      List<NotificationModel> listNotifications = state.existNotifications
          ? [...state.listNotifications!, event.notification]
          : [event.notification];
      emit(state.copyWith(
          existNotifications: true, listNotifications: listNotifications));
    });
    on<UpdateNotifications>((event, emit) {
      emit(state.copyWith(
          existNotifications: true, listNotifications: event.listNotification));
    });
  }
}
