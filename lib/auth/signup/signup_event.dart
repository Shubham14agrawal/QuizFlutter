abstract class SignupEvent {}

class SignupUsernameChanged extends SignupEvent {
  final String username;

  SignupUsernameChanged({required this.username});
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  SignupPasswordChanged({required this.password});
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  SignupEmailChanged({required this.email});
}

class SignupMobileNumberChanged extends SignupEvent {
  final String mobileNumber;

  SignupMobileNumberChanged({required this.mobileNumber});
}

class SignupImageChanged extends SignupEvent {
  final String image;
  SignupImageChanged({required this.image});
}

class SignupSubmitted extends SignupEvent {}
