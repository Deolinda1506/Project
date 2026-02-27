import 'package:equatable/equatable.dart';

/// State for the auth flow (unauthenticated, loading, authenticated, failure).
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state: not logged in.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Login or logout in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Successfully authenticated (no backend yet; holds display info).
class AuthAuthenticated extends AuthState {
  final String displayEmail;
  final String displayName;
  final String role;  // chw or clinician

  const AuthAuthenticated({
    required this.displayEmail,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object?> get props => [displayEmail, displayName, role];
}

/// Login failed (e.g. invalid email/password or phone not supported).
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
