import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

/// [User.empty] represents an unauthenticated user.

class User extends Equatable {
  const User({required this.id, this.email, this.photo, this.phoneNumber});

  final String? email;
  final String? id;
  final XFile? photo;
  final String? phoneNumber;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, photo, phoneNumber];

  Map<String, dynamic> toFireStore() {
    return {
      if (email != null) "email": email,
      if (id != null) "id": id,
      if (photo != null) "photo": photo,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
    };
  }
}
