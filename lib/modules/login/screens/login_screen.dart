import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/modules/login/cubit/login_cubit.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

@RoutePage()
class LoginScreen extends StatefulWidget implements AutoRouteWrapper {
  const LoginScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(AuthenticationRepository()),
      child: this,
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent),
      body: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) {
            context.replaceRoute(const ProfileRoute());
          } else if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication failed'),
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
                    Image.asset(
                      'assets/bloc_logo_small.png',
                      height: 120,
                    ),
                    const SizedBox(height: 30),
                    const _EmailField(),
                    const SizedBox(height: 15),
                    const _PasswordField(),
                    const SizedBox(height: 30),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return state.status.isInProgress
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: context.read<LoginCubit>().onLogin,
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                      },
                    ),
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
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          onChanged: (value) =>
              context.read<LoginCubit>().passwordChanged(value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            errorText: state.password.displayError != null
                ? 'Password must be 8 character long with upper,lower case,special character,number'
                : null,
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => context.replaceRoute(const CreateProfileRoute()),
      child: const Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
