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
Future<void> setAccessToken(WidgetRef ref, String token) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  await prefs.setString('ACCESSTOKEN', token);
}

final uidProvider = Provider<String?>((ref) {
  final asyncPrefs = ref.watch(sharedPreferencesProvider);
  return asyncPrefs.when(
    data: (prefs) => prefs.getString('UID'),
    loading: () => null,
    error: (error, stack) => null,
  );
});
Future<void> setUID(WidgetRef ref, String uid) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  await prefs.setString('UID', uid);
}
