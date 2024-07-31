import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasebloc/modules/logout/cubit/log_out_cubit.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebasebloc/core/models/user_model.dart' as user_model;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UserHomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const UserHomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LogOutCubit(),
      child: this,
    );
  }

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final storageRef = FirebaseStorage.instance.ref().child('Profile_Pics');
  final fireStoreInstance = FirebaseFirestore.instance;
  String? userImageUrl;
  user_model.User _user = user_model.User.empty;

  Future<String?> getImageUrl() async {
    try {
      final userImageURL = await storageRef.child(uid).getDownloadURL();
      setState(() {
        userImageUrl = userImageURL;
      });
    } catch (e) {}
    return null;
  }

  Future<user_model.User?> getUserCredentials() async {
    final docSnapshot =
        await fireStoreInstance.collection('users').doc(uid).get();
    if (docSnapshot.exists) {
      final user = user_model.User.fromFireStore(docSnapshot);
      setState(() {
        _user = user;
      });
    } else {
      print('User not found');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getImageUrl();
    getUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Container(
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
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: userImageUrl == null
                      ? const AssetImage('assets/fake_user_profile.webp')
                      : NetworkImage(userImageUrl!),
                ),
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
                        Text(
                          '   Email : ${_user.email} ',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        Text(
                          '  Contact : ${_user.phoneNumber}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
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
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Wait a moment..')));
          const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.logOutDone) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.replaceRoute(const LoginRoute());
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
