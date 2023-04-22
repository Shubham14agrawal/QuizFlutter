import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nagp_quiz/auth/login/login.dart';

import 'package:nagp_quiz/auth/signup/signup_block.dart';
import 'package:nagp_quiz/auth/signup/signup_event.dart';
import 'package:nagp_quiz/auth/signup/signup_state.dart';
import 'package:nagp_quiz/stores/quiz_store.dart';

import '../auth_repository.dart';
import '../login/login_submission.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignupBloc(
          authRepo: context.read<AuthRepository>(),
        ),
        child: _signupForm(context),
      ),
    );
  }

  Widget _signupForm(context) {
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                _imagePicker(context),
                _passwordField(),
                _emailField(),
                _mobileField(),
                _registerButton()
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) =>
            state.isValidUsername ? null : 'Username Length should be > 3',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _imagePicker(context) {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return IconButton(
          onPressed: () async {
            var selectedImage = await _getImage(ImageSource.gallery);
            var convertedImage = "";
            if (selectedImage != null) {
              convertedImage =
                  QuizStore.base64String(selectedImage.readAsBytesSync());
              context
                  .read<SignupBloc>()
                  .add(SignupImageChanged(image: convertedImage));
            }
          },
          icon: Icon(Icons.add_a_photo));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Password Length should be > 3',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Email',
        ),
        validator: (value) =>
            state.isValidEmail ? null : 'Email Length should be > 3',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupEmailChanged(email: value),
            ),
      );
    });
  }

  Widget _mobileField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.numbers),
          hintText: 'Mobile Number',
        ),
        validator: (value) =>
            state.isValidEmail ? null : 'Mobile Number Length should be 10',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupMobileNumberChanged(mobileNumber: value),
            ),
      );
    });
  }

  Widget _registerButton() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  context.read<SignupBloc>().add(SignupSubmitted());
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RepositoryProvider(
                            create: (context) => AuthRepository(),
                            child: LoginView(),
                          )));
                }
              },
              child: const Text('Register'),
            );
    });
  }

  /// Get from gallery/camera
  Future<File?> _getImage(source) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    return imageFile;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
