import 'package:task_manager/core/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModelNotifier extends StateNotifier<UserModel> {
  UserModelNotifier() : super(UserModel(email: '', password: ''));
  void clearUserModel() {
    state = UserModel(email: '', password: '');
  }

  void updateEmail(String email) {
    String? error;
    if (email.isEmpty) {
      error = '⚠️ Please enter the E-mail';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      error = '⚠️ Enter a valid E-mail';
    }

    state = state.copyWith(
      email: email,
      emailError: error,
    );
  }

  void updatePassword(String password) {
    String? error;
    if (password.isEmpty) {
      error = '⚠️ Please Enter the password';
    } else if (password.length < 6) {
      error = '⚠️ Password must be at least 6 characters long';
    }

    state = state.copyWith(
      password: password,
      passwordError: error,
    );
  }
}

final userModelProvider = StateNotifierProvider<UserModelNotifier, UserModel>(
  (ref) => UserModelNotifier(),
);
