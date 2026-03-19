import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/session/session_state.dart';
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/domain/repositories/auth_repository.dart';

class SessionController extends StateNotifier<SessionState> {
  SessionController(this._authRepository)
      : super(const SessionState(status: SessionStatus.signedOut));

  final AuthRepository _authRepository;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = SessionState(
      status: SessionStatus.loading,
      session: state.session,
    );

    try {
      final session = await _authRepository.signIn(
        email: email,
        password: password,
      );

      state = SessionState(
        status: SessionStatus.signedIn,
        session: session,
      );
    } on ApiException catch (error) {
      state = SessionState(
        status: SessionStatus.failure,
        errorMessage: error.message,
      );
    } catch (_) {
      state = const SessionState(
        status: SessionStatus.failure,
        errorMessage: '로그인 중 알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  void signOut() {
    state = const SessionState(status: SessionStatus.signedOut);
  }
}
