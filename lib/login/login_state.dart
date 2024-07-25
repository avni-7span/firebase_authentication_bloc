part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState(
      {required this.email, this.password, this.isValid = false, this.error});

  final Email email;
  final String? password;
  final bool isValid;
  final String? error;

  @override
  List<Object?> get props => [email, password, isValid, error];

  LoginState copyWith({
    Email? email,
    String? password,
    bool? isValid,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
    );
  }
}
