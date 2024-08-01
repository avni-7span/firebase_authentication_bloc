import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasebloc/core/models/user_model.dart' as user_model;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final storageRef = FirebaseStorage.instance.ref().child('Profile_Pics');
  final fireStoreInstance = FirebaseFirestore.instance;

  Future<void> getImageUrl() async {
    try {
      emit(state.copyWith(status: HomeStateStatus.imageLoading));
      final userImageURL = await storageRef.child(uid).getDownloadURL();
      emit(state.copyWith(
          userImageUrl: userImageURL, status: HomeStateStatus.imageLoaded));
    } catch (e) {
      emit(state.copyWith(status: HomeStateStatus.failure));
    }
  }

  Future<void> getUserCredentials() async {
    try {
      emit(state.copyWith(status: HomeStateStatus.userLoading));
      final docSnapshot =
          await fireStoreInstance.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final user = user_model.User.fromFireStore(docSnapshot);
        emit(state.copyWith(user: user, status: HomeStateStatus.userLoaded));
      } else {
        emit(state.copyWith(status: HomeStateStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStateStatus.failure));
    }
  }
}
