import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/model/todo_model.dart';
import 'package:task_manager/core/notification/notification.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/elevated_btn.dart';
import 'package:task_manager/core/widget/text_form_field.dart';
import 'package:task_manager/domain/service/todo/todo_repo.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';
import 'package:task_manager/infrastructure/riverpod/todo/todo_provider.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';
import 'package:task_manager/presentation/todo/widget/widget.dart';

final formKeyTodo = GlobalKey<FormState>();

class AddTodoScreen extends ConsumerWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(18),
        child: Form(
          key: formKeyTodo,
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
              const UserDropdown(),
              const CompletionStatusDropdown(),
              sizedBox15H,
              ElevatedBtnWidget(
                onPressed: () async {
                  if (formKeyTodo.currentState!.validate()) {
                    final taskModel = ref.read(taskFormProvider);
                    print(TodoModel(
                        userId: taskModel.assignedUser?.id ?? 0,
                        title: taskModel.title,
                        completed: taskModel.status == 'complete'));
                    final result = await TodoRepo().createTask(
                        ref,
                        TodoModel(
                            userId: taskModel.assignedUser?.id ?? 0,
                            title: taskModel.title,
                            completed: taskModel.status == 'complete'));
                    if (result == 'success') {
                      NotificationHandler.snakBarSuccess(
                          'Task create Successfully.😄', context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(todoNotifierProvider.notifier).getTodo(ref);
                      });
                    } else {
                      NotificationHandler.snakBarError(result, context);
                    }
                    clearDropDown(ref);
                    ref.read(taskFormProvider.notifier).clearModel();
                    NavigationHandler.pop(context);
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
    );
  }
}
