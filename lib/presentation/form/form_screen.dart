import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/date_picker.dart';
import 'package:task_manager/core/widget/elevated_btn.dart';
import 'package:task_manager/core/widget/text_form_field.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';

final formKey = GlobalKey<FormState>();

class FormScreen extends ConsumerWidget {
  const FormScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskForm = ref.watch(taskFormProvider);
    return Container(
      color: colorApp,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Todo'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsetsDirectional.all(18),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  TextFormWidget(
                    label: 'Title',
                    icon: FontAwesomeIcons.t,
                    onChanged: (value) => ref
                        .read(taskFormProvider.notifier)
                        .updateTitle(value ?? ''),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Title cannot be empty'
                        : null,
                  ),
                  TextFormWidget(
                    label: 'Description',
                    icon: FontAwesomeIcons.paragraph,
                    maxLines: 9,
                    onChanged: (value) => ref
                        .read(taskFormProvider.notifier)
                        .updateDescription(value ?? ''),
                    validator: (value) =>
                        value!.isEmpty ? 'Description cannot be empty' : null,
                  ),
                  const DatePickerWidget(),
                  const PriorityDropdown(),
                  const StatusDropdown(),
                  const UserDropdown(),
                  sizedBox15H,
                  ElevatedBtnWidget(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final taskModel = ref.read(taskFormProvider);
                        log('Title: ${taskModel.title}');
                        log('Description: ${taskModel.description}');
                        log('Due Date: ${taskModel.date}');
                        log('Priority: ${taskModel.priority}');
                        log('Status: ${taskModel.status}');
                        log('Assigned User: ${taskModel.assignedUser?.firstName}');
                      }
                    },
                    title: 'Create',
                    btnColor: colorApp,
                    colorTitle: colorWhite,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
