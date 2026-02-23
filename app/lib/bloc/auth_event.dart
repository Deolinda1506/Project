import 'package:equatable/equatable.dart';

/// Events for the auth flow (login / logout).
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User submitted email and password for sign-in.
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// User submitted phone number for SMS sign-in (not implemented yet).
class AuthPhoneLoginRequested extends AuthEvent {
  final String phone;

  const AuthPhoneLoginRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// User signed out.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
