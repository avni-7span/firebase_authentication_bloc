import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/modules/profile/cubit/profile_cubit.dart';
import 'package:firebasebloc/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CreateProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: this,
    );
  }
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent),
      body: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ProfileStateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong, please try again later'),
              ),
            );
            return;
          }
          if (state.status == ProfileStateStatus.loaded) {
            context.replaceRoute(const UserHomeRoute());
            return;
          }
          if (state.status == ProfileStateStatus.imageIsNull) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text('Please select a profile picture.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Let\'s finish up creating your profile',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 78,
                        backgroundColor: Colors.blueAccent,
                        child: BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            return CircleAvatar(
                              radius: 75,
                              backgroundImage: state.profileImage != null
                                  ? FileImage(File(state.profileImage!.path))
                                  : const AssetImage(
                                      'assets/fake_user_profile.webp'),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 8,
                        child: InkWell(
                          onTap:
                              context.read<ProfileCubit>().getImageFromGallery,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.blueAccent,
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  const PhoneNumberField(),
                  const SizedBox(height: 40),
                  const CreateProfileButton(),
                ],
              ),
            ),
          ),
        ),
      ),
      //),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<ProfileCubit>().onNumberChange(value),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Phone number',
              errorText: state.isValid ? null : 'Enter valid phone number'),
        );
      },
    );
  }
}

class CreateProfileButton extends StatelessWidget {
  const CreateProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state.status == ProfileStateStatus.loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: context.read<ProfileCubit>().onProfileCreate,
                child: const Text(
                  'CREATE PROFILE',
                  style: TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }
}
