part of 'log_out_cubit.dart';

sealed class LogOutState extends Equatable {
  const LogOutState();
}

final class LogOutInitial extends LogOutState {
  @override
  List<Object> get props => [];
}
