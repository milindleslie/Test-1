import 'package:flutter/material.dart';
import 'package:test_app/custom_widgets/app_widgets.dart';
import 'package:test_app/resources/colors.dart';
import 'package:test_app/screens/all_events.dart';

enum _Tab { TAB1, TAB2, TAB3, TAB4, TAB5 }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // init the TabController
    _tabController = TabController(vsync: this, length: _Tab.values.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController, // we set our instantiated TabController as the controller
        children: <Widget>[
          AllEventsScreen(),
          Scaffold(),
          Scaffold(),
          Scaffold(),
          Scaffold(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: _Tab.values.map((_Tab tab) => BottomNavigationBarItem(icon: _getAssetForTab(tab), label: '')).toList(),
        ),
      ),
    );
  }

  /// Get the asset icon for the given tab
  Widget _getAssetForTab(_Tab tab) {
    // check if the given tab parameter is the current active tab
    final active = tab == _Tab.values[_currentTabIndex];
    var asset = '';

    switch (tab) {
      case _Tab.TAB1:
        asset = 'assets/icons/icon.svg';
        break;
      case _Tab.TAB2:
        asset = 'assets/icons/Shape.svg';
        break;
      case _Tab.TAB3:
        asset = 'assets/icons/Group 477.svg';
        break;
      case _Tab.TAB4:
        asset = 'assets/icons/Group 2.svg';
        break;
      case _Tab.TAB5:
        asset = 'assets/icons/Group 108.svg';
        break;
    }

    return AppWidgets.svgIcon(icon: asset, color: active ? AppColors.appBlueColor : Colors.blueGrey, size: 18);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
      _tabController.animateTo(index, curve: Curves.easeOut);
    });
  }
}
