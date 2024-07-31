import 'package:equatable/equatable.dart';

/// [User.empty] represents an unauthenticated user.

class User extends Equatable {
  const User({required this.id, this.email, this.phoneNumber});

  final String? email;
  final String? id;
  final String? phoneNumber;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, phoneNumber];

  Map<String, dynamic> toFireStore() {
    return {
      if (email != null) "email": email,
      if (id != null) "id": id,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
    };
  }
}
