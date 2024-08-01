part of 'home_cubit.dart';

enum HomeStateStatus { initial, loaded, failure, loading }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStateStatus.initial,
    this.user = user_model.User.empty,
  });

  final user_model.User user;
  final HomeStateStatus status;

  @override
  List<Object?> get props => [user, status];

  HomeState copyWith({
    user_model.User? user,
    HomeStateStatus? status,
  }) {
    return HomeState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
