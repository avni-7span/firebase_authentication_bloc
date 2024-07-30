import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasebloc/core/models/user_model.dart';
import 'package:firebasebloc/core/repository/authentication_repository.dart';
import 'package:firebasebloc/core/validators/phoneNumber.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  final db = FirebaseFirestore.instance;
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
        emit(state.copyWith(isLoading: true));
        await addUserInfoInFireStore(
            authInstance.currentUser?.uid ?? '',
            state.profileImage!,
            authInstance.currentUser?.email!,
            state.phoneNumber.value);
        emit(state.copyWith(
            isLoading: false, status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
              error: e.toString(), status: FormzSubmissionStatus.failure),
        );
      }
    }
    // final user = User(
    //   photo: state.profileImage,
    //   id: authInstance.currentUser?.uid ?? '',
    //   email: authInstance.currentUser?.email,
    //   phoneNumber: state.phoneNumber.value,
    // );
  }

  Future addUserInfoInFireStore(
      String id, XFile photo, String? email, String phoneNumber) async {
    final user =
        User(id: id, email: email, phoneNumber: phoneNumber, photo: photo);
    await db.collection('Users').add(User(id: id).toFireStore());
  }
}
