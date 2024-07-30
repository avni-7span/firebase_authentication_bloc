part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

class AppLogOutEvent extends AppEvent {
  const AppLogOutEvent();
}

class AppUserChangeEvent extends AppEvent {
  const AppUserChangeEvent(this.user);
  final User user;
}
