part of 'news_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  loaded,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final CustomError error;
  const AuthState({
    required this.status,
    required this.error,
  });

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [status, error];


  AuthState copyWith({
    AuthStatus? status,
    List<News>? news,
    CustomError? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
