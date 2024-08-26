import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/notification/notification.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/alert_box.dart';
import 'package:task_manager/domain/demo/tast_state.dart';
import 'package:task_manager/infrastructure/riverpod/todo/todo_provider.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';
import 'package:task_manager/presentation/home/widget/home_widget.dart';
import 'package:task_manager/presentation/todo/todo_screen.dart';

class HomeScrn extends ConsumerStatefulWidget {
  const HomeScrn({super.key});

  @override
  _HomeScrnState createState() => _HomeScrnState();
}

class _HomeScrnState extends ConsumerState<HomeScrn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoNotifierProvider.notifier).getTodo(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    String? greeting;
    if (currentHour >= 0 && currentHour < 12) {
      greeting = 'Good Morning ☀️';
    } else if (currentHour >= 12 && currentHour < 17) {
      greeting = 'Good Afternoon 🌤️';
    } else if (currentHour >= 17 && currentHour < 21) {
      greeting = 'Good Evening 🌙';
    } else {
      greeting = 'Good Night 🌜';
    }
    return Consumer(
      builder: (context, ref, child) {
        final todoState = ref.watch(todoNotifierProvider);
        return Container(
          color: colorApp,
          child: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(size.width, size.height * 0.19),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Hello,',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                              backgroundColor: colorApp,
                              child: IconButton(
                                  onPressed: () {
                                    AlertBoxHandler.logoutAlertBox(
                                        context, ref);
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: colorWhite,
                                  )),
                            )
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            greeting ?? '',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        sizedBox10H,
                        SegmentedTabControl(
                          barDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)),
                          tabTextColor: colorApp,
                          selectedTabTextColor: Colors.white,
                          squeezeIntensity: 2,
                          tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                          indicatorDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)),
                          textStyle:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          tabs: [
                            SegmentTab(
                              label: '❌ Incomplete',
                              color: colorApp,
                              backgroundColor: colorlight,
                            ),
                            SegmentTab(
                              label: '✅ Completed',
                              backgroundColor: colorlight,
                              color: colorApp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    todoState.status == TodoStateStatus.loading
                        ? ListView(
                            children: List.generate(
                            10,
                            (index) => TodoListWidgetShimmer(index: index),
                          ))
                        : todoState.status == TodoStateStatus.error
                            ? Center(
                                child: Text('Error: ${todoState.errorMessage}'))
                            : ListView.builder(
                                itemCount: todoState.tasks
                                        ?.where((task) => !task.completed)
                                        .length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final incompleteTasks = todoState.tasks
                                          ?.where((task) => !task.completed)
                                          .toList() ??
                                      [];
                                  final task = incompleteTasks[index];
                                  return TodoListWidget(
                                    size: size,
                                    index: index,
                                    task: task,
                                    ref: ref,
                                  );
                                },
                              ),
                    todoState.status == TodoStateStatus.loading
                        ? ListView(
                            children: List.generate(
                            10,
                            (index) => TodoListWidgetShimmer(index: index),
                          ))
                        : todoState.status == TodoStateStatus.error
                            ? Center(
                                child: Text('Error: ${todoState.errorMessage}'))
                            : ListView.builder(
                                itemCount: todoState.tasks
                                        ?.where((task) => task.completed)
                                        .length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final completeTasks = todoState.tasks
                                          ?.where((task) => task.completed)
                                          .toList() ??
                                      [];
                                  final task = completeTasks[index];
                                  return TodoListWidget(
                                    size: size,
                                    index: index,
                                    task: task,
                                    ref: ref,
                                  );
                                },
                              ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: colorApp,
                  onPressed: () {
                    if (!AppDevConfig.isNetwork) {
                      NotificationHandler.snakBarWarning(
                          'You are offline', context);
                    } else {
                      clearDropDown(ref);
                      NavigationHandler.navigateTo(context, const TodoScreen());
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    color: colorWhite,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
