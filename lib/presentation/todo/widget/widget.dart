import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/constant/enum.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';

final completionStatusProvider =
    StateProvider<CompletionStatus?>((ref) => null);

class CompletionStatusDropdown extends ConsumerWidget {
  const CompletionStatusDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(completionStatusProvider.state).state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox15H,
        const Text(
          'Completion Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        sizedBox10H,
        DropdownButtonFormField<CompletionStatus>(
          value: selectedStatus,
          dropdownColor: colorWhite,
          hint: const Text("Select Completion Status"),
          decoration: const InputDecoration(
            labelText: 'Completion Status',
            border: OutlineInputBorder(),
          ),
          items: CompletionStatus.values.map((CompletionStatus status) {
            return DropdownMenuItem<CompletionStatus>(
              value: status,
              child:
                  Text(status.toString().split('.').last.replaceAll('_', ' ')),
            );
          }).toList(),
          onChanged: (CompletionStatus? newStatus) {
            if (newStatus != null) {
              ref.read(completionStatusProvider.state).state = newStatus;
              ref.read(taskFormProvider.notifier).updateStatus(
                  newStatus.toString().split('.').last.replaceAll('_', ' '));
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a Completion Status';
            }
            return null;
          },
        ),
      ],
    );
  }
}
