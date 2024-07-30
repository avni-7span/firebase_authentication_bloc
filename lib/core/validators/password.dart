import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([this.confirmPassword]) : super.pure('');

  const Password.dirty([super.value = '', this.confirmPassword])
      : super.dirty();

  final String? confirmPassword;

  static final _passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    if (confirmPassword != null && confirmPassword == value) {
      return null;
    } else {
      return _passwordRegExp.hasMatch(value ?? '')
          ? null
          : PasswordValidationError.invalid;
    }
  }
}

///r'^
//   (?=.*[A-Z])       // should contain at least one upper case
//   (?=.*[a-z])       // should contain at least one lower case
//   (?=.*?[0-9])      // should contain at least one digit
//   (?=.*?[!@#\$&*~]) // should contain at least one Special character
//   .{8,}             // Must be at least 8 characters in length
// $
// r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$
