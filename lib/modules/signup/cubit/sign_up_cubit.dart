import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasebloc/core/models/user_model.dart';
import 'package:firebasebloc/core/repository/authentication_failure.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/core/validators/email.dart';
import 'package:firebasebloc/core/validators/password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password]),
      ),
    );
  }

  void confirmedPasswordChanged(String confirmPassword) {
    final confirmedPassword =
        Password.dirty(state.password.value, confirmPassword);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([confirmedPassword]),
      ),
    );
  }

  Future<void> onSignUp() async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        confirmedPassword: confirmPassword,
        isValid: Formz.validate([email, password, confirmPassword]),
      ),
    );
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final user = await _authenticationRepository.signUp(
          email: state.email.value,
          password: state.password.value,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .set(
              User(
                id: user.user!.uid,
                email: user.user?.email,
              ).toFireStore(),
            );

        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on SignUpWithEmailAndPasswordFailure catch (e) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
