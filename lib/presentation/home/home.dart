import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/model/task_model.dart';
import 'package:task_manager/core/routes/routes.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/infrastructure/domain/demo/tast_state.dart';
import 'package:task_manager/infrastructure/riverpod/task/task_provider.dart';
import 'package:task_manager/presentation/form/form_screen.dart';

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
      ref.read(taskNotifierProvider.notifier).getTodo(ref);
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
        final taskState = ref.watch(taskNotifierProvider);
        return Container(
          color: colorApp,
          child: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(size.width, size.height * 0.17),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            'Hello,',
                            style: TextStyle(fontSize: 20),
                          ),
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
                    taskState.status == TaskStateStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : taskState.status == TaskStateStatus.error
                            ? Center(
                                child: Text('Error: ${taskState.errorMessage}'))
                            : ListView.builder(
                                itemCount: taskState.tasks
                                        ?.where((task) => !task.completed)
                                        .length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final incompleteTasks = taskState.tasks
                                          ?.where((task) => !task.completed)
                                          .toList() ??
                                      [];
                                  final task = incompleteTasks[index];
                                  return TodoListWidget(
                                    size: size,
                                    index: index,
                                    task: task,
                                  );
                                },
                              ),
                    taskState.status == TaskStateStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : taskState.status == TaskStateStatus.error
                            ? Center(
                                child: Text('Error: ${taskState.errorMessage}'))
                            : ListView.builder(
                                itemCount: taskState.tasks
                                        ?.where((task) => task.completed)
                                        .length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final completeTasks = taskState.tasks
                                          ?.where((task) => task.completed)
                                          .toList() ??
                                      [];
                                  final task = completeTasks[index];
                                  return TodoListWidget(
                                    size: size,
                                    index: index,
                                    task: task,
                                  );
                                },
                              ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
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
  });
  final int index;
  final Size size;
  final TaskModel task;
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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: size.width - 45),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.accents[index % Colors.accents.length]
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          task.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.accents[index % Colors.accents.length],
                          ),
                        ),
                      ),
                      sizedBox5H,
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorApp,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      task.completed ? "Completed" : "Pending",
                      style: const TextStyle(
                        color: colorWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]))
        ]));
  }
}
