import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/authentication_repository/authentication_repository.dart';
import 'package:firebasebloc/login_cubit/login_cubit.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(AuthenticationRepository()),
      // create:(_)=> LoginCubit(context.read<AuthenticationRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Welcome',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status.isSuccess) {
              context.pushRoute(const ProfileRoute());
            } else if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text(state.errorMessage ?? 'Authentication failed'),
                  ),
                );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/bloc_logo_small.png',
                      height: 120,
                    ),
                    const SizedBox(height: 30),
                    const _EmailField(),
                    const SizedBox(height: 15),
                    const _PasswordField(),
                    const SizedBox(height: 30),
                    const _LoginButton(),
                    const SizedBox(height: 15),
                    const _SignupButton()
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('LoginScreen_email'),
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Email',
              errorText:
                  state.email.displayError != null ? 'Invalid Email' : null),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('LoginScreen_password'),
          obscureText: true,
          onChanged: (value) =>
              context.read<LoginCubit>().passwordChanged(value),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Password',
              errorText: state.password.displayError != null
                  ? 'Password must contain small, capital letters and numbers'
                  : null),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                key: const Key('LoginScreen_loginButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed:
                    state.isValid ? context.read<LoginCubit>().onLogin : null,
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.black),
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
    return ElevatedButton(
      key: const Key('LoginScreen_navigate_signup'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => context.pushRoute(const SignUpRoute()),
      child: const Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
