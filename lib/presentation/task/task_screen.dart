import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/model/task_model.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';
import 'package:task_manager/presentation/form/form_screen.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';

class TaskScrn extends ConsumerWidget {
  const TaskScrn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final filteredTasks = ref
        .watch(taskProvider)
        .where((task) => isSameDay(task.createAt!, selectedDate))
        .toList();
    final size = MediaQuery.of(context).size;
    return Container(
      color: colorApp,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(size.width, size.height * 0.2),
            child: EasyDateTimeLine(
              initialDate: DateTime.timestamp(),
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.dayOnly(),
              ),
              onDateChange: (selectedDate) {
                ref.read(selectedDateProvider.notifier).state = selectedDate;
              },
            ),
          ),
          body: filteredTasks.isEmpty
              ? const Center(child: Text('No tasks available.'))
              : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    return TaskTileWidget(
                      size: size,
                      index: index,
                      tasks: filteredTasks,
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              clearDropDown(ref);
              NavigationHandler.navigateTo(context, const FormScreen());
            },
            backgroundColor: colorApp,
            child: const FaIcon(
              FontAwesomeIcons.folderPlus,
              color: colorWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({
    super.key,
    required this.size,
    required this.index,
    required this.tasks,
  });

  final Size size;
  final int index;
  final List<TaskModel> tasks;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorBlack.withOpacity(0.1))),
              width: size.width,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  backgroundImage: NetworkImage(
                                      tasks[index].assignedUser?.avatar ?? ''),
                                ),
                                sizedBox5W,
                                Text(
                                  "${tasks[index].assignedUser?.firstName} ${tasks[index].assignedUser?.lastName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: priorityColors[tasks[index].priority] ??
                                  colorGreen,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          )
                        ],
                      ),
                      sizedBox5H,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tasks[index].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            tasks[index].createAt != null
                                ? DateFormat('dd MMM yyyy')
                                    .format(tasks[index].date!)
                                : '',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      sizedBox5H,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tasks[index].description.trim(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: colorApp,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              tasks[index].status.trim(),
                              style: const TextStyle(
                                  fontSize: 11, color: colorWhite),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ]))
        ],
      ),
    );
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
