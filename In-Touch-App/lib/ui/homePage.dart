import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intouch/ui/infoPage.dart';
import 'package:intouch/ui/callHistoryPage.dart';
import 'package:intouch/ui/profilePage.dart';
import 'package:intouch/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          InfoScreen(),
          CallHistoryScreen(),
          ProfileScreen(),
        ],
        controller: pageController,
        physics: BouncingScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: (pageNumber == 0)
                  ? Constants.mainColor
                  : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.call,
              color: (pageNumber == 1)
                  ? Constants.mainColor
                  : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (pageNumber == 2)
                  ? Constants.mainColor
                  : Colors.grey,
            ),
          ),
        ],
        onTap: navigationTapped,
        currentIndex: pageNumber,
      ),
    );
  }

  void onPageChanged(int pageNumber) {
    setState(() {
      this.pageNumber = pageNumber;
    });
  }

  void navigationTapped(int pageNumber) {
    pageController.jumpToPage(pageNumber);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
