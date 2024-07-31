import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/core/validators/phoneNumber.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  final db = FirebaseFirestore.instance;
  final storageReference = FirebaseStorage.instance.ref().child('Profile_Pics');
  final authInstance = AuthenticationRepository();

  Future<void> getImageFromGallery() async {
    emit(
      state.copyWith(isLoading: true),
    );
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(
      state.copyWith(isLoading: false, profileImage: image),
    );
  }

  void numberChanged(String value) {
    final number = PhoneNumber.dirty(value);
    emit(
      state.copyWith(
        phoneNumber: number,
        isValid: Formz.validate([number]),
      ),
    );
  }

  Future<void> onCreatingProfile() async {
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    emit(
      state.copyWith(
        isValid: Formz.validate([phoneNumber]),
      ),
    );
    if (state.profileImage == null) {
      emit(state.copyWith(imageError: true));
    }
    if (state.isValid && state.profileImage != null) {
      //print('ready to store data');
      try {
        emit(state.copyWith(isLoading: true, imageError: false));
        await addUserPhoneNumber(state.phoneNumber.value);
        emit(state.copyWith(
            isLoading: false, status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
              error: e.toString(), status: FormzSubmissionStatus.failure),
        );
      }
    }
  }

  Future<void> addUserPhoneNumber(String phoneNumber) async {
    await storageReference.child(authInstance.currentUser!.uid).putFile(
          File(state.profileImage!.path),
        );
    await db
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .update({'Phone number': phoneNumber});
  }
}
