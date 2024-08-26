import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/constant/enum.dart';
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

class TodoScreen extends ConsumerWidget {
  const TodoScreen({this.todoModel, super.key});
  final TodoModel? todoModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (todoModel != null) {
        ref.read(taskFormProvider.notifier).updateTitle(todoModel?.title ?? '');
        ref.watch(completionStatusProvider.state).state = todoModel!.completed
            ? CompletionStatus.complete
            : CompletionStatus.incomplete;
        ref.read(taskFormProvider.notifier).updateAssignedUser(
              AppDevConfig.userList.firstWhere(
                (element) => element.id == todoModel?.userId,
              ),
            );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(todoModel != null ? 'Update Todo' : 'Add Todo'),
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
                controller: todoModel != null
                    ? TextEditingController(text: todoModel?.title ?? '')
                    : null,
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
                    String result = todoModel != null
                        ? await TodoRepo().updateTask(
                            ref,
                            todoModel!.id ?? 0,
                            TodoModel(
                                userId: taskModel.assignedUser?.id ?? 0,
                                title: taskModel.title,
                                completed: taskModel.status == 'complete'))
                        : await TodoRepo().createTask(
                            ref,
                            TodoModel(
                                userId: taskModel.assignedUser?.id ?? 0,
                                title: taskModel.title,
                                completed: taskModel.status == 'complete'));
                    if (result == 'success') {
                      NotificationHandler.snakBarSuccess(
                          todoModel != null
                              ? 'Task update Successfully.😄'
                              : 'Task create Successfully.😄',
                          context);
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
                title: todoModel != null ? 'Update' : 'Create',
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
