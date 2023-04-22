import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'login_submission.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState()) {
    on<LoginMobileNumberChanged>((event, emit) =>
        emit(state.copyWith(mobileNumber: event.mobileNumber)));

    on<LoginPasswordChanged>(
        (event, emit) => emit(state.copyWith(password: event.password)));

    on<LoginFormStatusChanged>(
        (event, emit) => emit(state.copyWith(formStatus: event.formStatus)));

    on<LoginSubmitted>((event, emit) {
      formSubmission(event, emit, state);
    });
  }

  formSubmission(event, emit, state) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      var authuser = await authRepo.login(state);
      if (authuser != null) {
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      }
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e)));
    }
  }
}
