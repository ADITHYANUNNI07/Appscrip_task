import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final accessTokenProvider = Provider<String?>((ref) {
  final asyncPrefs = ref.watch(sharedPreferencesProvider);
  return asyncPrefs.when(
    data: (prefs) => prefs.getString('ACCESSTOKEN'),
    loading: () => null,
    error: (error, stack) => null,
  );
});

final userUidProvider = Provider<String?>((ref) {
  final asyncPrefs = ref.watch(sharedPreferencesProvider);
  return asyncPrefs.when(
    data: (prefs) => prefs.getString('USERUID'),
    loading: () => null,
    error: (error, stack) => null,
  );
});
