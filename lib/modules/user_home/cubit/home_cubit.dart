import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebloc/core/models/user_model.dart' as user_model;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final fireStoreInstance = FirebaseFirestore.instance;

  Future<void> getUserDetails() async {
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));
      final docSnapshot =
          await fireStoreInstance.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final user = user_model.User.fromFireStore(docSnapshot);
        emit(state.copyWith(user: user, status: HomeStateStatus.loaded));
      } else {
        emit(state.copyWith(status: HomeStateStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStateStatus.failure));
    }
  }
}
