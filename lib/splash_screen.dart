import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkNavigation();
  }

  void checkNavigation() {
    RepositoryProvider.of<AuthenticationRepository>(context).currentUser != null
        ? context.replaceRoute(const UserHomeRoute())
        : context.replaceRoute(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(color: Colors.cyan, fontSize: 50),
        ),
      ),
    );
  }
}
