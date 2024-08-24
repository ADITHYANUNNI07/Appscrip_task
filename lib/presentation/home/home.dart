import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/model/todo_model.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/alert_box.dart';
import 'package:task_manager/domain/demo/tast_state.dart';
import 'package:task_manager/infrastructure/riverpod/todo/todo_provider.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';
import 'package:task_manager/presentation/todo/todo.dart';
import 'package:redacted/redacted.dart';

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
                    clearDropDown(ref);
                    NavigationHandler.navigateTo(context, const TodoScreen());
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
