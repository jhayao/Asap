import 'dart:convert';
import 'dart:developer';
import 'package:animated_background/fitness_app/ui/frienddetails/friend_details_page.dart';
import 'package:animated_background/src/api/api.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:smart_select/smart_select.dart';

import '../fintness_app_theme.dart';
import '../models/student_list_data.dart';

class UserList extends StatefulWidget {
  @override
  const UserList({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  State createState() => new DyanmicList();
}
class DyanmicList extends State<UserList>  with TickerProviderStateMixin{
  List<Widget> litems = [];
  int tag =0;
  double topBarOpacity = 0.0;
  Animation<double> topBarAnimation;
  AnimationController animationController;
  final ScrollController scrollController = ScrollController();
  List<String> options = [
    'All', 'Event\'s Today', 'Event\'s Done', 'Incoming Events'
  ];
  String value = 'all';
  List<S2Choice<String>> options2 = [
    S2Choice<String>(value: 'all', title: 'All Courses'),
    S2Choice<String>(value: 'BSIT', title: 'BSIT'),
    S2Choice<String>(value: 'BTLEd-ICT', title: 'BTLEd-ICT'),
    S2Choice<String>(value: 'BTLEd-HE', title: 'BTLEd-HE'),
    S2Choice<String>(value: 'BTLEd-IA', title: 'BTLEd-IA'),
    S2Choice<String>(value: 'BSEd-TLE', title: 'BSEd-TLE'),
  ];
  String sort = 'lastName';
  List<S2Choice<String>> sorts = [
    S2Choice<String>(value: 'lastName', title: 'Last Name'),
    S2Choice<String>(value: 'firstName', title: 'First Name'),
    S2Choice<String>(value: 'studentNumber', title: 'Student Number'),
  ];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    loadEvents=getEvents();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    litems.add(EventsLoad());
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }
  void _navigateToFriendDetails(StudentsListData friend, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return FriendDetailsPage(friend, avatarTag: avatarTag);
        },
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 45,
                            right: 16,
                            top: 10 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Students',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
  @override
  Widget build (BuildContext ctxt) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: new Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top + 1,
                  bottom: 62 + MediaQuery.of(context).padding.bottom,
                ),
                child: Row(children: <Widget>[
                Expanded(
                  child: SmartSelect<String>.single(
                    title: 'Course',
                    value: value,
                    choiceItems: options2,
                    onChange: (selected) {
                      setState(() => {value = selected.value,});
                    },
                    modalType: S2ModalType.popupDialog,
                    modalHeader: false,
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        trailing: const Icon(Icons.arrow_drop_down),
                        isTwoLine: true,
                      );
                    },
                  ),
                ),
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: SmartSelect<String>.single(
                      title: 'Sort By',
                      value: sort,
                      choiceItems: sorts,
                      onChange: (selected) {
                        setState(() => {sort = selected.value,});
                      },
                      modalType: S2ModalType.popupDialog,
                      modalHeader: false,
                      tileBuilder: (context, state) {
                        return S2Tile.fromState(
                          state,
                          trailing: const Icon(Icons.arrow_drop_down),
                          isTwoLine: true,
                        );
                      },
                    ),
                  )
                ],
                )
              ),
              getAppBarUI(),
              SizedBox(height: 10,),
              Column(
                children: [
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.only(
                        top: AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.top + 62 ,
                        bottom:MediaQuery.of(context).padding.bottom,
                      ),
                      child: EventsLoad(),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
  Future loadEvents;
  Future getEvents() async{
    studentListData.clear();
    var response;
    response =  await CallApi().getData('studentList/$value/$sort');
    var event = json.decode(response.body);
    // print(event);
    String studentNumber;
    String lastName;
    String giveName;
    String middleName;
    List<String> fullName;
    String course;
    final String _url ='https://ssc.codes/storage/';
    int x = 0;
    for(var u in event) {
      studentNumber = u['studentnumber'];
      lastName =u['LastName'];
      giveName = u['GivenName'];
      middleName = u['MiddleName'];
      course = u['DegreeProgram'];
      fullName = <String>[u['LastName']+ ',',u['GivenName'],u['MiddleName']];
      StudentsListData data = StudentsListData(studentNumber, lastName,giveName,middleName,fullName,_url +  u['avatar'],course);
      studentListData.add(data);
      x++;
    }

    return true;
  }

  List<StudentsListData> studentListData = [];
  Widget EventsLoad()
  {
    List<StudentsListData> _categorize= null;
    return FutureBuilder(
        future: loadEvents,
        builder: (context,snapshot){
          if(ConnectionState.done == snapshot.connectionState) {
            studentListData.sort((a,b){
              if(sort=='studentNumber')
                return a.studentNumber.toLowerCase().compareTo(b.studentNumber.toLowerCase());
              else if(sort=='lastName')
                {
                  return a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
                }
              else
                {
                  return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
                }
            });
            if(value!='all')
              _categorize = studentListData.where((element) => element.course.contains(value)).toList();
            else
              _categorize = studentListData;
            if(_categorize.length>=1)
            {
              return ListView.builder(
                  itemCount: _categorize.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {

                    final item = _categorize[index];
                    return GFListTile(
                        avatar:Hero( tag :index,child: GFAvatar(backgroundImage:NetworkImage(item.imagePath))),
                        titleText: item.fullName.join(" "),
                        subtitleText: item.studentNumber + ',' + item.course,
                        icon: Icon(Icons.favorite),
                        onTap: () {
                          _navigateToFriendDetails(item, index);
                        }
                    );
                  });
            }
            else{
              return Padding(
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top + 62 ,
                  bottom:MediaQuery.of(context).padding.bottom,
                ),
                child: EmptyListWidget(
                    title: 'No Events',
                    subTitle: 'No  Events available yet',
                    image: 'lib/resources/images/im_emptyIcon_2.png',
                    titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7)),
                    subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))
                ),
              );
            }

          }
          else
          {
            return SpinKitCircle(color: Colors.blue,);
          }
        }
    );
  }
}