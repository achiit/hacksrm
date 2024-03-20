import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:smart_home/english/common/app_colors.dart';
import 'package:smart_home/english/features/home/views/profile.dart';
import 'package:smart_home/english/features/home/views/servicepage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _bottomNavIndex = 0; // default index of the first screen

  final iconList = <IconData>[
    Icons.home,
    Icons.account_circle,
  ];

  // Define the widgets for each tab
  final List<Widget> tabs = [
    ServicesPage(), // Assuming ServicePage is the widget for the service tab
    ProfilePage(), // Assuming ProfilePage is the widget for the profile tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: tabs[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.black : Colors.black.withOpacity(0.5);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              iconList[index],
              size: 35,
              color: color,
            ),
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        backgroundColor: AppColors.primarycream,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        // Other properties can be customized as per your requirement
      ),
    );
  }
}
