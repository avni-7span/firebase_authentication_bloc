import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasebloc/authentication_repository/authentication_repository.dart';
import 'package:firebasebloc/formz_validators/confirmed_password.dart';
import 'package:formz/formz.dart';
import 'package:firebasebloc/formz_validators/email.dart';
import 'package:firebasebloc/formz_validators/password.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid:
            Formz.validate([email, state.password, state.confirmedPassword]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
        password: password.value, value: state.confirmedPassword.value);
    emit(
      state.copyWith(
        password: password,
        // confirmedPassword: confirmedPassword,
        isValid:
            Formz.validate([password, state.confirmedPassword, state.email]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword =
        ConfirmedPassword.dirty(password: state.password.value, value: value);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([state.password, confirmedPassword]),
      ),
    );
  }

  Future onSignUp() async {
    if (!state.isValid) return;
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await _authenticationRepository.signUp(
          email: state.email.value, password: state.password.value);
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
            status: FormzSubmissionStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }
}
