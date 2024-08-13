import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/core/validators/phone_number.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  final db = FirebaseFirestore.instance;
  final storageReference = FirebaseStorage.instance.ref().child('Profile_Pics');
  final authInstance = AuthenticationRepository();

  Future<void> getImageFromGallery() async {
    emit(state.copyWith(status: ProfileStateStatus.imagePickerLoading));

    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    emit(
      state.copyWith(
        profileImage: image,
        status: ProfileStateStatus.imagePickerLoaded,
      ),
    );
  }

  void onNumberChange(String value) {
    final number = PhoneNumber.dirty(value);
    emit(
      state.copyWith(
        phoneNumber: number,
        isValid: Formz.validate([number]),
      ),
    );
  }

  Future<void> onProfileCreate() async {
    emit(state.copyWith(status: ProfileStateStatus.createLoading));
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    emit(
      state.copyWith(
        isValid: Formz.validate([phoneNumber]),
      ),
    );
    if (state.profileImage == null) {
      emit(
        state.copyWith(
          status: ProfileStateStatus.imageIsNull,
          // isValid: false,
        ),
      );
      return;
    }
    if (state.isValid && state.status != ProfileStateStatus.imageIsNull) {
      try {
        emit(state.copyWith(status: ProfileStateStatus.loading));

        await addUserNumberAndImageUrl(state.phoneNumber.value);
        emit(
          state.copyWith(
            status: ProfileStateStatus.loaded,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            error: e.toString(),
            status: ProfileStateStatus.failure,
          ),
        );
      }
    }
  }

  Future<void> addUserNumberAndImageUrl(String phoneNumber) async {
    await storageReference.child(authInstance.currentUser!.uid).putFile(
          File(state.profileImage!.path),
        );
    final userImageURL = await storageReference
        .child(authInstance.currentUser!.uid)
        .getDownloadURL();
    await db
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .update({'phone_number': phoneNumber, 'image_url': userImageURL});
  }
}
