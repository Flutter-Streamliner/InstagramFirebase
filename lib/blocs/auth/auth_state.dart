part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User user;
  final AuthStatus status;
  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
  });

  factory AuthState.authenticated({@required auth.User user}) =>
      AuthState(user: user, status: AuthStatus.authenticated);

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.unknown() => const AuthState();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [user, status];
}
