import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/constant/enum.dart';

final priorityProvider = StateProvider<Priority?>((ref) => null);
final statusProvider = StateProvider<Status?>((ref) => null);
