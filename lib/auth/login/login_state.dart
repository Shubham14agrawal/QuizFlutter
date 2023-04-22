import 'login_submission.dart';

class LoginState {
  final String mobileNumber;
  bool get isValidMobileNumber => mobileNumber.length == 10;

  final String password;
  bool get isValidPassword => password.length > 3;

  final FormSubmissionStatus formStatus;
  LoginState(
      {this.mobileNumber = '',
      this.password = '',
      this.formStatus = const InitialFormStatus()});

  LoginState copyWith({
    String? mobileNumber,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
        mobileNumber: mobileNumber ?? this.mobileNumber,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
