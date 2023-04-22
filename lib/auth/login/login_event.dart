import 'package:flutter/cupertino.dart';
import 'package:nagp_quiz/auth/login/login_state.dart';

import 'login_submission.dart';

abstract class LoginEvent {}

class LoginMobileNumberChanged extends LoginEvent {
  final String mobileNumber;

  LoginMobileNumberChanged({required this.mobileNumber});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginFormStatusChanged extends LoginEvent {
  final FormSubmissionStatus formStatus;

  LoginFormStatusChanged({required this.formStatus});
}

class LoginSubmitted extends LoginEvent {}
