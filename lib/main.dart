import 'package:firebase_core/firebase_core.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/firebase_options.dart';
import 'package:firebasebloc/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authenticationRepository = AuthenticationRepository();
  runApp(App(authenticationRepository: authenticationRepository));
}

class App extends StatelessWidget {
  App({
    super.key,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final _router = AppRoute();
  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepository(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: _router.delegate(),
        routeInformationParser: _router.defaultRouteParser(),
      ),
    );
  }
}
