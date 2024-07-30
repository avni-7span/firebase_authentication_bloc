import 'package:equatable/equatable.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(const LogOutState());

  Future<void> logOut() async {
    emit(state.copyWith(isLoading: true));
    try {
      AuthenticationRepository().logOut();
      emit(state.copyWith(isLoading: false, logOutDone: true));
    } catch (e) {}
  }
}
