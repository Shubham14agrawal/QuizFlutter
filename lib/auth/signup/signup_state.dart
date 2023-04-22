import '../login/login_submission.dart';

class SignupState {
  final String username;
  bool get isValidUsername => username.length > 3;

  final String password;
  bool get isValidPassword => password.length > 3;

  final String email;
  bool get isValidEmail => email.length > 3;

  final String mobileNumber;
  bool get isValidMobileNumber => mobileNumber.length == 10;

  final String image;

  final FormSubmissionStatus formStatus;

  SignupState(
      {this.username = '',
      this.password = '',
      this.email = '',
      this.mobileNumber = '',
      this.image = '',
      this.formStatus = const InitialFormStatus()});

  SignupState copyWith({
    String? username,
    String? password,
    String? email,
    String? mobileNumber,
    String? image,
    FormSubmissionStatus? formStatus,
  }) {
    return SignupState(
        username: username ?? this.username,
        password: password ?? this.password,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        image: image ?? this.image,
        formStatus: formStatus ?? this.formStatus);
  }
}
