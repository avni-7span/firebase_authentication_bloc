part of 'home_cubit.dart';

enum HomeStateStatus {
  initial,
  imageLoading,
  imageLoaded,
  userLoading,
  userLoaded,
  failure,
}

class HomeState extends Equatable {
  const HomeState(
      {this.status = HomeStateStatus.initial,
      this.user = user_model.User.empty,
      this.userImageUrl});

  final String? userImageUrl;
  final user_model.User user;
  final HomeStateStatus status;

  @override
  List<Object?> get props => [userImageUrl, user, status];

  HomeState copyWith({
    String? userImageUrl,
    user_model.User? user,
    HomeStateStatus? status,
  }) {
    return HomeState(
      userImageUrl: userImageUrl ?? this.userImageUrl,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
