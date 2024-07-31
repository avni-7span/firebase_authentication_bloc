import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/modules/logout/cubit/log_out_cubit.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LogOutCubit(),
      child: this,
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocListener<LogOutCubit, LogOutState>(
        listener: (context, state) {
          if (state.isLoading) {
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text('Wait a moment..')));
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.logOutDone) {
            context.replaceRoute(const LoginRoute());
          }
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80,
                width: 100,
                child: FloatingActionButton(
                  onPressed: context.read<LogOutCubit>().logOut,
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
