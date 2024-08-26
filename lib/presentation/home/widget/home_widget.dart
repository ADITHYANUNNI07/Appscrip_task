import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/model/todo_model.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/alert_box.dart';
import 'package:task_manager/presentation/todo/todo_screen.dart';
import 'package:redacted/redacted.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({
    super.key,
    required this.size,
    required this.index,
    required this.task,
    required this.ref,
  });
  final int index;
  final Size size;
  final TodoModel task;
  final WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
              height: size.height * 0.15,
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width,
              child: Stack(children: [
                Container(
                  height: size.height * 0.2,
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.accents[index % Colors.accents.length],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: size.width - 45),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors
                                  .accents[index % Colors.accents.length]
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      NetworkImage(task.user?.avatar ?? ''),
                                ),
                                sizedBox5W,
                                Text(
                                  "${task.user?.firstName} ${task.user?.lastName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colorBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<int>(
                            icon:
                                const FaIcon(FontAwesomeIcons.ellipsisVertical),
                            onSelected: (value) {},
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: const Text("Update"),
                                onTap: () {
                                  NavigationHandler.navigateTo(
                                      context, TodoScreen(todoModel: task));
                                },
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: const Text("Delete"),
                                onTap: () {
                                  AlertBoxHandler.deleteTodoAlertBox(
                                      context, ref, task);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      sizedBox5H,
                      Text(task.title)
                    ],
                  ),
                ),
              ]))
        ]));
  }
}

class TodoListWidgetShimmer extends StatelessWidget {
  const TodoListWidgetShimmer({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
            height: size.height * 0.15,
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            width: size.width,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                            ),
                            sizedBox5W,
                            const Text(
                              "helloooooooooo",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colorBlack,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: List.generate(
                            3,
                            (index) => Container(height: 7, width: 7),
                          ),
                        )
                      ],
                    ),
                    sizedBox10H,
                    Container(height: 10, width: 100),
                    sizedBox10H,
                    Container(height: 10, width: 200),
                    sizedBox10H,
                    Container(height: 10, width: 300),
                  ],
                ),
              ),
            ]),
          ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800),
              ))
        ]));
  }
}
