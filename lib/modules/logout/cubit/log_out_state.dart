part of 'log_out_cubit.dart';

class LogOutState extends Equatable {
  const LogOutState(
      {this.isLoading = false,
      this.logOutDone = false,
      this.errorMessage = ''});

  final bool isLoading;
  final bool logOutDone;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, logOutDone, errorMessage];

  LogOutState copyWith({
    bool? isLoading,
    bool? logOutDone,
    String? errorMessage,
  }) {
    return LogOutState(
      isLoading: isLoading ?? this.isLoading,
      logOutDone: logOutDone ?? this.logOutDone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
