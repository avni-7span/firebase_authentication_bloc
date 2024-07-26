part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.status = FormzSubmissionStatus.initial,
      this.errorMessage,
      this.isValid = false});

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final String? errorMessage;
  final FormzSubmissionStatus status;
  final bool isValid;

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    String? errorMessage,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, confirmedPassword, errorMessage, isValid];
}
