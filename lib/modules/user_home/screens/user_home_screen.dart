import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/modules/logout/cubit/log_out_cubit.dart';
import 'package:firebasebloc/modules/user_home/cubit/home_cubit.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UserHomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const UserHomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => LogOutCubit()),
      BlocProvider(create: (context) => HomeCubit()..getUserDetails())
    ], child: this);
  }

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  static const profileFake =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fuser-profile&psig=AOvVaw1jaYo-1761V0TAiDGXJrQe&ust=1722581715641000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCPit9Yub04cDFQAAAAAdAAAAABAE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == HomeStateStatus.loading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wait a moment...'),
                ),
              );
            } else if (state.status == HomeStateStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong,Please try again later'),
                ),
              );
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                color: Colors.grey,
                height: 110,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: state.status == HomeStateStatus.loading
                          ? const SizedBox.square(
                              child: CircularProgressIndicator())
                          : CircleAvatar(
                              radius: 75,
                              backgroundImage:
                                  state.status == HomeStateStatus.loaded
                                      ? NetworkImage(
                                          state.user.imageURL ?? profileFake)
                                      : const NetworkImage(profileFake)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                state.status == HomeStateStatus.loading
                                    ? 'Loading...'
                                    : state.status == HomeStateStatus.loaded
                                        ? state.user.email!
                                        : '_____@gmail.com',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                state.status == HomeStateStatus.loading
                                    ? 'Loading...'
                                    : state.status == HomeStateStatus.loaded
                                        ? state.user.phoneNumber!
                                        : 'xxxxxxxxxx',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: const LogOutButton());
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wait a moment..'),
            ),
          );
          const Center(
            child: CircularProgressIndicator(),
          );
          return;
        }
        if (state.logOutDone) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.replaceRoute(const LoginRoute());
          return;
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong'),
            ),
          );
          return;
        }
      },
      child: FloatingActionButton.extended(
        onPressed: context.read<LogOutCubit>().logOut,
        backgroundColor: Colors.blue,
        label: const Text(
          'LOGOUT',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
