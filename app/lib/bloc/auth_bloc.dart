import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthPhoneLoginRequested>(_onPhoneLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) {
    final email = event.email.trim();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      emit(const AuthFailure('Please enter a valid email address.'));
      return;
    }
    if (event.password.isEmpty || event.password.length < 6) {
      emit(const AuthFailure('Password must be at least 6 characters.'));
      return;
    }
    emit(const AuthLoading());
    // No backend: treat as success. When backend exists, call API then emit AuthAuthenticated or AuthFailure.
    emit(AuthAuthenticated(displayEmail: email));
  }

  void _onPhoneLoginRequested(
    AuthPhoneLoginRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthFailure('Phone (SMS) login is not implemented yet.'));
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitial());
  }
}
