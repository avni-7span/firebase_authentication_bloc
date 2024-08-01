part of 'profile_cubit.dart';

enum ProfileStateStatus {
  initial,
  loading,
  loaded,
  imagePickerLoading,
  imagePickerLoaded,
  imageIsNull,
  failure
}

class ProfileState extends Equatable {
  const ProfileState({
    this.profileImage,
    this.phoneNumber = const PhoneNumber.pure(),
    this.isValid = false,
    this.status = ProfileStateStatus.initial,
    this.error,
  });

  final XFile? profileImage;
  final PhoneNumber phoneNumber;
  final ProfileStateStatus status;
  final bool isValid;
  final String? error;

  ProfileState copyWith({
    XFile? profileImage,
    PhoneNumber? phoneNumber,
    ProfileStateStatus? status,
    bool? isValid,
    String? error,
  }) {
    return ProfileState(
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [profileImage, phoneNumber, status, isValid, error];
}
