import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/presentation/home/home.dart';
import 'package:task_manager/presentation/search/search.dart';
import 'package:task_manager/presentation/task/task_screen.dart';

class PageIndexProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}

class DashboardScrn extends StatelessWidget {
  const DashboardScrn({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageIndexProvider(),
      child: Consumer<PageIndexProvider>(
        builder: (context, provider, _) {
          List<Widget> pages = [
            const HomeScrn(),
            const TaskScrn(),
            const SearchScrn(),
          ];

          return Scaffold(
            body: pages[provider.index],
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: GNav(
                onTabChange: (index) {
                  provider.setIndex(index);
                },
                tabBackgroundColor: colorApp,
                activeColor: colorWhite,
                padding: const EdgeInsets.all(10),
                tabActiveBorder: Border.all(
                  color: const Color(0xFF773BFF).withOpacity(0.5),
                ),
                tabs: const [
                  GButton(
                    iconActiveColor: colorWhite,
                    icon: CupertinoIcons.house_alt,
                    text: 'Home',
                  ),
                  GButton(
                    icon: CupertinoIcons.list_bullet,
                    text: 'Task',
                  ),
                  GButton(
                    icon: CupertinoIcons.search,
                    text: 'Search',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
