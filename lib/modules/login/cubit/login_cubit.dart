import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebloc/core/repository/authentication_failure.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/core/validators/email.dart';
import 'package:firebasebloc/core/validators/password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
          email: email, isValid: Formz.validate([email, state.password])),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> onLoginTap() async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([email, password]),
      ),
    );

    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logInWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        );
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        );
      } on FirebaseAuthException catch (e) {
        final errorMessage =
            LogInWithEmailAndPasswordFailure.fromCode(e.code).message;
        emit(
          state.copyWith(
            errorMessage: errorMessage,
            status: FormzSubmissionStatus.failure,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.toString(),
            status: FormzSubmissionStatus.failure,
          ),
        );
      }
    }
  }
}
