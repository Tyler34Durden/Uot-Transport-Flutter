part of 'notifications_cubit.dart';

abstract class NotificationsState {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<dynamic> notifications; // Change to dynamic to allow passing the full notification object
  const NotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
