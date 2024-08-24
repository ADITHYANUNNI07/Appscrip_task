import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/constant/enum.dart';
import 'package:task_manager/core/model/user_model.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/date_picker.dart';
import 'package:task_manager/infrastructure/riverpod/form/form_provider.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';
import 'package:task_manager/presentation/todo/widget/widget.dart';

class PriorityDropdown extends ConsumerWidget {
  const PriorityDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPriority = ref.watch(priorityProvider.state).state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox15H,
        const Text(
          'Priority',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        sizedBox10H,
        DropdownButtonFormField<Priority>(
            value: selectedPriority,
            dropdownColor: colorWhite,
            hint: const Text("Select Priority"),
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
            ),
            items: Priority.values.map((Priority priority) {
              return DropdownMenuItem<Priority>(
                value: priority,
                child: Text(priority.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Priority? newPriority) {
              if (newPriority != null) {
                ref.read(priorityProvider.state).state = newPriority;
                ref
                    .read(taskFormProvider.notifier)
                    .updatePriority(newPriority.toString().split('.').last);
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a priority';
              }
              return null;
            }),
      ],
    );
  }
}

class StatusDropdown extends ConsumerWidget {
  const StatusDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(statusProvider.state).state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox15H,
        const Text(
          'Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        sizedBox10H,
        DropdownButtonFormField<Status>(
          value: selectedStatus,
          dropdownColor: colorWhite,
          hint: const Text("Select Status"),
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: Status.values.map((Status status) {
            return DropdownMenuItem<Status>(
              value: status,
              child:
                  Text(status.toString().split('.').last.replaceAll('_', ' ')),
            );
          }).toList(),
          onChanged: (Status? newStatus) {
            if (newStatus != null) {
              ref.read(statusProvider.state).state = newStatus;
              ref.read(taskFormProvider.notifier).updateStatus(
                  newStatus.toString().split('.').last.replaceAll('_', ' '));
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a Status';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class UserDropdown extends ConsumerWidget {
  const UserDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = AppDevConfig.userList;
    final assignedUser = ref.watch(taskFormProvider).assignedUser;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox15H,
        const Text(
          'Assign to User',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        sizedBox10H,
        DropdownButtonFormField<UserModel>(
          decoration: const InputDecoration(
            labelText: 'Assign to User',
            border: OutlineInputBorder(),
          ),
          value: assignedUser,
          items: userList.map((UserModel user) {
            return DropdownMenuItem<UserModel>(
              value: user,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar ?? ''),
                  ),
                  sizedBox5W,
                  Text("${user.firstName} ${user.lastName}"),
                ],
              ),
            );
          }).toList(),
          onChanged: (UserModel? user) {
            if (user != null) {
              ref.read(taskFormProvider.notifier).updateAssignedUser(user);
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a User';
            }
            return null;
          },
          hint: const Text('Assign to User'),
        ),
      ],
    );
  }
}

clearDropDown(WidgetRef ref) {
  ref.read(priorityProvider.state).state = null;
  ref.read(statusProvider.state).state = null;
  ref.watch(completionStatusProvider.state).state = null;
  ref.read(taskFormProvider.notifier).updateAssignedUser(null);
  ref.read(taskFormProvider.notifier).clearModel();
  ref.read(dobProvider.state).state = null;
}
