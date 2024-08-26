import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';
import 'package:task_manager/presentation/form/form_screen.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';
import 'package:task_manager/presentation/task/widget/task_widget.dart';

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
