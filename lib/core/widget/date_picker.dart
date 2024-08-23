import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/constant/constant.dart';

final dobProvider = StateProvider<DateTime?>((ref) => null);

class DatePickerWidget extends ConsumerWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(dobProvider.state).state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox15H,
        const Text(
          'Due Date',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        sizedBox10H,
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Due Date',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(
            text: selectedDate != null
                ? DateFormat('dd MMM yyyy').format(selectedDate)
                : '',
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2200));
            if (pickedDate != null) {
              ref.read(dobProvider.state).state = pickedDate;
            }
          },
        ),
      ],
    );
  }
}
