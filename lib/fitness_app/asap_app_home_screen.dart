
import 'package:animated_background/fitness_app/models/tabIcon_data.dart';
import 'package:animated_background/fitness_app/test.dart';
import 'package:animated_background/fitness_app/traning/event_screen.dart';
import 'package:animated_background/fitness_app/Events/events_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fintness_app_theme.dart';
import 'Dashboard/dashboard_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class AsapAppHomeScreen extends StatefulWidget {
  // changeIndex(int x)=>createState().changeIndex(x);
  @override
  _AsapAppHomeScreenState createState() => _AsapAppHomeScreenState();
}

class _AsapAppHomeScreenState extends State<AsapAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  PageController _pageController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );
  List<Widget> views;
  int index =0;
  bool _isLoggedIn = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    _pageController = PageController();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = MyDashboardScreen(animationController: animationController,,);


    views=[MyDashboardScreen(animationController: animationController,changeBody: this.changeBody),EventScreen(animationController: animationController,),EventsScreen(animationController: animationController,)];
    super.initState();
  }

  void _checkIfLoggedIn() async
  {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    print(user);
    if(user['role_id'] == 1) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }
  void changeBody(int x)
  {
    setState(() {
      this.index =x;
      _pageController.jumpToPage(this.index);
    });


  }
  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if(_isLoggedIn)
                return PageView(
                  controller: _pageController,
                  onPageChanged: (indexs){
                    setState(() {
                      index = indexs;
                    });
                  },
                  children: <Widget>[
                    Container(child: MyDashboardScreen(animationController: animationController,changeBody: this.changeBody,),),
                    Container(child: EventScreen(animationController: animationController,),),
                    Container(child: ListDisplay(animationController: animationController,)),
                    Container(color: Colors.red,),
                  ],
                );
              else
                return PageView(
                  controller: _pageController,
                  onPageChanged: (indexs){
                    setState(() {
                      index = indexs;
                    });
                  },
                  children: <Widget>[
                    Container(child: EventScreen(animationController: animationController,),),
                    Container(child: MyDashboardScreen(animationController: animationController,changeBody: this.changeBody,),),
                    Container(child: EventsScreen(animationController: animationController,),),
                    Container(color: Colors.blue,),
                  ],
                );
          }
        ),

        bottomNavigationBar: bottomNav(),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }



  Widget bottomNav()
  {


    return  BottomNavyBar(
      selectedIndex: index,
      showElevation: true,

      itemCornerRadius: 8,
      curve: Curves.easeInBack,
      onItemSelected: (indexs) => setState(() {
        index = indexs;
        _pageController.jumpToPage(index);
      }),
      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.apps),
          title: Text('Home'),
          activeColor: Colors.red,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          title: Text('Users'),
          activeColor: Colors.purpleAccent,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text("Events"),
          activeColor: Colors.pink,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
          activeColor: Colors.blue,
          textAlign: TextAlign.center,
        ),
      ],
    );

  }
  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {

            if (index == 0 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDashboardScreen(animationController: animationController,changeBody: this.changeBody);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      EventScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
