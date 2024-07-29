import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LogOutInitial());
}
