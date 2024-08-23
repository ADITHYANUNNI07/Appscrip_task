import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordVisibilityNotifier extends StateNotifier<bool> {
  PasswordVisibilityNotifier() : super(true);

  void togglePasswordVisibility() {
    state = !state;
  }
}

final passwordVisibilityProvider =
    StateNotifierProvider<PasswordVisibilityNotifier, bool>(
  (ref) => PasswordVisibilityNotifier(),
);
