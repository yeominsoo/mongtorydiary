import 'package:mongtory_diary/domain/models/auth_session.dart';

enum SessionStatus {
  unknown,
  loading,
  signedOut,
  signedIn,
  failure,
}

class SessionState {
  const SessionState({
    required this.status,
    this.session,
    this.errorMessage,
  });

  final SessionStatus status;
  final AuthSession? session;
  final String? errorMessage;

  SessionState copyWith({
    SessionStatus? status,
    AuthSession? session,
    String? errorMessage,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
