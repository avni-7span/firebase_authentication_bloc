import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebasebloc/core/models/user_model.dart';
import 'package:firebasebloc/core/repository/authentication_failure.dart';

// extension on firebase_auth.User {
//   /// Maps a [firebase_auth.User] into a [User].
//
//   User get toUser {
//     return User(id: uid, email: email, name: displayName, photo: photoURL);
//   }
// }

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  static final AuthenticationRepository _singleton =
      AuthenticationRepository._internal();

  factory AuthenticationRepository() {
    return _singleton;
  }

  AuthenticationRepository._internal()
      : _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // static const userCacheKey = '__user_cache_key__';

  firebase_auth.User? get currentUser {
    return firebase_auth.FirebaseAuth.instance.currentUser;
  }

  // Stream<User> get user {
  //   return _firebaseAuth.authStateChanges().map((firebaseUser) {
  //     final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
  //     return user;
  //   });
  // }

  Future<firebase_auth.UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential cred =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<firebase_auth.UserCredential> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user;
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
