import 'package:formz/formz.dart';

enum PhoneNumberValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  // for user that entered first time , then there must not error messages therefore pure
  const PhoneNumber.pure() : super.pure('');

  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  static final RegExp _numberRegExp = RegExp(
    r'^(?:[+0]9)?[0-9]{10}$',
  );

  @override
  PhoneNumberValidationError? validator(String? value) {
    return _numberRegExp.hasMatch(value ?? '')
        ? null
        : PhoneNumberValidationError.invalid;
  }
}
