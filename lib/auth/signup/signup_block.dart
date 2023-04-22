import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../stores/quiz_store.dart';
import '../auth_repository.dart';
import '../login/login_submission.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepo;

  SignupBloc({required this.authRepo}) : super(SignupState()) {
    on<SignupUsernameChanged>(
        (event, emit) => emit(state.copyWith(username: event.username)));

    on<SignupPasswordChanged>(
        (event, emit) => emit(state.copyWith(password: event.password)));

    on<SignupEmailChanged>(
        (event, emit) => emit(state.copyWith(email: event.email)));

    on<SignupMobileNumberChanged>((event, emit) =>
        emit(state.copyWith(mobileNumber: event.mobileNumber)));

    on<SignupImageChanged>(
        (event, emit) => emit(state.copyWith(image: event.image)));

    on<SignupSubmitted>((event, emit) => emit(formSubmission(state)));
  }

  imageSelection(state, event) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    String convertedImage = "";
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      convertedImage = QuizStore.base64String(imageFile.readAsBytesSync());
    }

    event.copyWith(image: convertedImage);
    event.setImage(convertedImage);
  }

  formSubmission(state) async {
    state.copyWith(formStatus: FormSubmitting());

    try {
      await authRepo.register(state);
      state.copyWith(formStatus: SubmissionSuccess());
    } catch (e) {
      state.copyWith(formStatus: SubmissionFailed(e));
    }
  }
}
