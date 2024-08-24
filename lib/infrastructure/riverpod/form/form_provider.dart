import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/constant/enum.dart';
import 'package:task_manager/core/model/user_model.dart';

final priorityProvider = StateProvider<Priority?>((ref) => null);
final statusProvider = StateProvider<Status?>((ref) => null);
final userListProvider = StateProvider<List<UserModel>?>((ref) => null);
