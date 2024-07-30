part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState(
      {this.profileImage,
      this.phoneNumber = const PhoneNumber.pure(),
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.imageError = false,
      this.isLoading = false,
      this.error});

  final XFile? profileImage;
  final PhoneNumber phoneNumber;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool imageError;
  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [
        profileImage,
        phoneNumber,
        status,
        isValid,
        imageError,
        isLoading,
        error
      ];

  ProfileState copyWith({
    XFile? profileImage,
    PhoneNumber? phoneNumber,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? imageError,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      imageError: imageError ?? this.imageError,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// final class ProfileInitial extends ProfileState {
//   @override
//   List<Object> get props => [];
// }
