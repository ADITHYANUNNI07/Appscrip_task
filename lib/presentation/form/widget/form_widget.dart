import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/constant/enum.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/infrastructure/riverpod/form/form_provider.dart';

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
            }
          },
        ),
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
            }
          },
        ),
      ],
    );
  }
}
