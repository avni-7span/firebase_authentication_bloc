import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// [User.empty] represents an unauthenticated user.

class User extends Equatable {
  const User({required this.id, this.email, this.phoneNumber, this.imageURL});

  final String? email;
  final String? id;
  final String? phoneNumber;
  final String? imageURL;

  static const empty = User(id: '');

  // bool get isEmpty => this == User.empty;
  // bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, phoneNumber, imageURL];

  Map<String, dynamic> toFireStore() {
    return {
      if (email != null) "email": email,
      if (id != null) "id": id,
      if (phoneNumber != null) "phone_number": phoneNumber,
      if (imageURL != null) 'image_url': imageURL
    };
  }

  factory User.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
        id: data?['id'],
        email: data?['email'],
        phoneNumber: data?['phone_number'],
        imageURL: data?['image_url']);
  }
}
