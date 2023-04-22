import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nagp_quiz/auth/signup/signup.dart';

import '../../home_screen.dart';
import '../auth_repository.dart';
import 'login_block.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'login_submission.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
        ),
        child: _loginForm(context),
      ),
    );
  }

  Widget _loginForm(context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _mobileNumberField(),
                _passwordField(),
                _loginButton(),
                _signup(context),
              ],
            ),
          ),
        ));
  }

  Widget _mobileNumberField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.numbers),
          hintText: 'Mobile Number',
        ),
        validator: (value) =>
            state.isValidMobileNumber ? null : 'Mobile Number must be 10 digit',
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginMobileNumberChanged(mobileNumber: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.formStatus is FormSubmitting) {
        return CircularProgressIndicator();
      } else if (state.formStatus is SubmissionSuccess) {
        return ElevatedButton(
            onPressed: () => (Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RepositoryProvider(
                      create: (context) => AuthRepository(),
                      child: const HomeScreen(),
                    )))),
            child: const Text("Logged in Successfull !! Click to continue"));
      } else {
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState != null &&
                _formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginSubmitted());
            }
          },
          child: const Text('Login'),
        );
      }
    });
  }

  Widget _signup(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 38,
      child: ElevatedButton(
        child: Text("Sign Up"),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RepositoryProvider(
                    create: (context) => AuthRepository(),
                    child: SignUpView(),
                  )));
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
