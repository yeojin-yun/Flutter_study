// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus authStaus;
  final fbAuth.User? user;
  AuthState({
    required this.authStaus,
    this.user,
  });

  factory AuthState.unknown() {
    return AuthState(authStaus: AuthStatus.unknown);
  }

  @override
  String toString() => 'AuthState(authStaus: $authStaus, user: $user)';

  @override
  bool operator ==(covariant AuthState other) {
    if (identical(this, other)) return true;

    return other.authStaus == authStaus && other.user == user;
  }

  @override
  int get hashCode => authStaus.hashCode ^ user.hashCode;

  AuthState copyWith({
    AuthStatus? authStaus,
    fbAuth.User? user,
  }) {
    return AuthState(
      authStaus: authStaus ?? this.authStaus,
      user: user ?? this.user,
    );
  }
}
