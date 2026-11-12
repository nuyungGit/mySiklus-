import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../../../core/services/supabase_service.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isGuestMode;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isGuestMode = false,
  });

  bool get isAuthenticated => user != null || isGuestMode;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isGuestMode,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isGuestMode: isGuestMode ?? this.isGuestMode,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    checkCurrentUser();
  }

  void checkCurrentUser() {
    final currentSupabaseUser = SupabaseService.instance.currentUser;
    if (currentSupabaseUser != null) {
      state = state.copyWith(
        user: UserModel(
          id: currentSupabaseUser.id,
          name: currentSupabaseUser.userMetadata?['name'] as String? ?? 'Muslimah',
          email: currentSupabaseUser.email ?? '',
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  /// Masuk sebagai tamu (Guest Mode - pencatatan offline lokal)
  void enterGuestMode(String displayName) {
    state = state.copyWith(
      isGuestMode: true,
      user: UserModel(
        id: 'guest_user_local',
        name: displayName.isNotEmpty ? displayName : 'Ukhti Muslimah',
        email: 'local@mysiklus.app',
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Login via Supabase Auth
  Future<bool> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await SupabaseService.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          user: UserModel(
            id: user.id,
            name: user.userMetadata?['name'] as String? ?? 'Muslimah',
            email: user.email ?? '',
            createdAt: DateTime.now(),
          ),
        );
        return true;
      }
      state = state.copyWith(isLoading: false, errorMessage: 'Gagal mendapatkan data akun');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Registrasi akun baru via Supabase Auth
  Future<bool> signUp(String name, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await SupabaseService.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          user: UserModel(
            id: user.id,
            name: name,
            email: email,
            createdAt: DateTime.now(),
          ),
        );
        return true;
      }
      state = state.copyWith(isLoading: false, errorMessage: 'Registrasi gagal');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Logout
  Future<void> signOut() async {
    if (!state.isGuestMode) {
      await SupabaseService.instance.client.auth.signOut();
    }
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
