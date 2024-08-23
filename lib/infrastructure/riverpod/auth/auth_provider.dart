import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/constant/enum.dart';
import 'package:task_manager/core/model/user_model.dart';
import 'package:task_manager/infrastructure/domain/service/auth/auth_repo.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepo authRepo;

  AuthNotifier(this.authRepo) : super(AuthState.initial);

  Future<void> signup(UserModel userModel, WidgetRef ref) async {
    state = AuthState.loading;

    final result = await authRepo.signup(userModel);
    if (result == 'success') {
      state = AuthState.success;
    } else {
      log(result);
      ref.read(authErrorProvider.notifier).state = result;
      state = AuthState.error;
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepoProvider)),
);

final authErrorProvider = StateProvider<String?>(
    (ref) => 'Note: Only defined users succeed registration');

final authRepoProvider = Provider<AuthRepo>((ref) => AuthRepo());
