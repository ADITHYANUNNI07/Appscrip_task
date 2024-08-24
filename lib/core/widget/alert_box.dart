import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/model/todo_model.dart';
import 'package:task_manager/core/notification/notification.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/domain/service/todo/todo_repo.dart';
import 'package:task_manager/infrastructure/helper/shared_preference.dart';
import 'package:task_manager/infrastructure/riverpod/todo/todo_provider.dart';
import 'package:task_manager/presentation/login/login.dart';

class AlertBoxHandler {
  static deleteTodoAlertBox(
      BuildContext context, WidgetRef ref, TodoModel model) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(
            width: 200,
            child: Text(
              'Delete this Task?',
              textAlign: TextAlign.center,
            )),
        content: const SizedBox(
          width: 200,
          child: Text(
            "You won't be able to recover this task after deleting it.",
            textAlign: TextAlign.center,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.red),
            ),
            onPressed: () async {
              final result = await TodoRepo().deleteTodo(ref, model);
              if (result == 'success') {
                NotificationHandler.snakBarSuccess(
                    'Task Delete SuccessFully', context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(todoNotifierProvider.notifier).getTodo(ref);
                });
              } else {
                NotificationHandler.snakBarError(result, context);
              }
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static logoutAlertBox(BuildContext context, WidgetRef ref) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(
            width: 200,
            child: Text(
              'Log out of your account?',
              textAlign: TextAlign.center,
            )),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.red),
            ),
            onPressed: () async {
              await setAccessToken(ref, '');
              await setUID(ref, '');
              NavigationHandler.navigateOff(context, const LoginScrn());
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
