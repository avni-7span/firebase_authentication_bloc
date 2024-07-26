import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';

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
    Future.delayed(Duration(seconds: 3), () => context.pushRoute(LoginRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Screen'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          'Welcome',
          style: TextStyle(color: Colors.orange, fontSize: 50),
        ),
      ),
    );
  }
}
