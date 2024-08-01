import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/modules/signup/cubit/sign_up_cubit.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget implements AutoRouteWrapper {
  const SignUpScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
        create: (ctx) => SignUpCubit(AuthenticationRepository()), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocListener<SignUpCubit, SignUpState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            context.replaceRoute(const CreateProfileRoute());
          }
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Sign In failed'),
                ),
              );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SignUp Now!',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/bloc_logo_small.png',
                      height: 120,
                    ),
                    const SizedBox(height: 30),
                    const _EmailField(),
                    const SizedBox(height: 15),
                    const _PasswordField(),
                    const SizedBox(height: 15),
                    const _ConfirmedPasswordField(),
                    const SizedBox(height: 30),
                    const _SignupButton(),
                    const SizedBox(height: 15),
                    const _LoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('SignUpScreen_email'),
          onChanged: (value) => context.read<SignUpCubit>().emailChanged(value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Email',
            errorText:
                state.email.displayError != null ? 'Invalid Email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({super.key});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('SignUpScreen_password'),
          obscureText: isVisible,
          onChanged: (value) =>
              context.read<SignUpCubit>().passwordChanged(value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            errorText: state.password.displayError != null
                ? 'Password must contain small, capital letters and numbers'
                : null,
            suffixIcon: IconButton(
              icon: isVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmedPasswordField extends StatefulWidget {
  const _ConfirmedPasswordField({super.key});

  @override
  State<_ConfirmedPasswordField> createState() =>
      _ConfirmedPasswordFieldState();
}

class _ConfirmedPasswordFieldState extends State<_ConfirmedPasswordField> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextFormField(
          key: const Key('SignUpScreen_confirmed_password'),
          obscureText: isVisible,
          onChanged: (value) =>
              context.read<SignUpCubit>().confirmedPasswordChanged(value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Confirm Password',
            errorText: state.confirmedPassword.displayError != null
                ? 'Password do not match'
                : null,
            suffixIcon: IconButton(
              icon: isVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('SignUp_screen_signup_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // minimumSize: Size(
                  //   MediaQuery.sizeOf(context).width * 0.8,
                  //   50,
                  // ),
                ),
                onPressed: context.read<SignUpCubit>().onSignUp,
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.black),
                ),
              );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('SignUpScreen_navigate_LoginScreen'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => context.replaceRoute(const LoginRoute()),
      child: const Text(
        'LOGIN IN EXISTING ACCOUNT',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
