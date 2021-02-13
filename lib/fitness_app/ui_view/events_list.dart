import 'dart:convert';

import 'package:animated_background/fitness_app/fintness_app_theme.dart';
import 'package:animated_background/fitness_app/models/events_list_data.dart';
import 'package:animated_background/main.dart';
import 'package:animated_background/src/api/api.dart';
import 'package:animated_background/src/entities/ssc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import '../../main.dart';

class EventsList extends StatefulWidget {
  const EventsList(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.status})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final status;
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Future eventFuture;
  List<EventsListData> eventsListData = [];

  @override
  void initState() {
    eventFuture = getEvents();
    print(widget.status);
    // getEvents();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    getData();

  }

  Future getEvents() async{
    var response ;
    eventsListData.clear();
    if (widget.status == "today")
    {
      response =  await CallApi().getData('getEventToday');
    }
    else if(widget.status == "incoming")
    {
      response =  await CallApi().getData('getIncomingToday');
    }
    else if(widget.status == "done")
    {
      response =  await CallApi().getData('getDoneToday');
    }
    else
    {
      response =  await CallApi().getData('getEvents');
    }
    var event = json.decode(response.body);
    int counter = 2 ;
    String imagePath = 'assets/fitness_app/breakfast.png';
    String titleTxt="Breakfast";
    String startColor = '#FA7D82';
    String endColor='#FA7D82';
    List<String> date=<String>['Bread,', 'Peanut butter,', 'Apple'];
    final String _url ='https://ssc.codes/storage/';
    int fines=0;
    for(var u in event) {
      titleTxt = u['title'];
      fines =u['fines'];
      date = <String>[u['date'],u['start_time'],u['end_time']];

      EventsListData data = EventsListData(_url +  u['image'], titleTxt, fines, date, startColor, endColor);
      eventsListData.add(data);

    }
    print(eventsListData.length);
    return true;
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: SingleChildScrollView(
                child: FutureBuilder(
                    future: eventFuture,
                    builder:(context,snapshot){
                      if(snapshot.hasData){
                        if(eventsListData.length != 0)
                          return Container(
                            height: MediaQuery.of(context).size.height - 250,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              // Let the ListView know how many items it needs to build.
                              itemCount: eventsListData.length,
                              // Provide a builder function. This is where the magic happens.
                              // Convert each item into a widget based on the type of item it is.
                              itemBuilder: (context, index) {
                                final item = eventsListData[index];
                                return   GFCard(
                                  boxFit: BoxFit.cover,
                                  image: Image.network(item.imagePath),
                                  title: GFListTile(
                                    avatar: GFAvatar(
                                      backgroundImage: NetworkImage(item.imagePath),
                                    ),
                                    title: Text(item.titleTxt),
                                    subtitle: Text(item.date[0]),
                                  ),
                                  content: Text("Date: " + item.date[0] + '\n' +
                                      "Sign in: " + item.date[1].substring(0,item.date[1].length -3)  + '\n' +
                                      "Sign out: " + item.date[2].substring(0,item.date[2].length -3) + '\n'
                                    ,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.nearlyBlack,
                                    ),
                                  ),
                                  buttonBar: GFButtonBar(
                                    children: <Widget>[
                                      GFButton(
                                        onPressed: () {},
                                        text: 'Buy',
                                      ),
                                      GFButton(
                                        onPressed: () {},
                                        text: 'Cancel',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        else
                        {
                          return GFListTile(
                              avatar:GFAvatar(backgroundImage: AssetImage('lib/resources/images/empty.png')),
                              titleText:'Empty',
                              subtitleText:'No Event Found',
                              icon: Icon(Icons.favorite)
                          );
                        }
                      }
                      else{
                        return SpinKitWave(
                          color: Colors.blueAccent,
                          size: 50.0,);
                      }
                    }
                )
            ),
          ),
        );
      },
    );
  }
}

class EventsView extends StatelessWidget {
  const EventsView(
      {Key key, this.eventsListData, this.animationController, this.animation})
      : super(key: key);

  final EventsListData eventsListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 150,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(eventsListData.endColor)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(eventsListData.startColor),
                            HexColor(eventsListData.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              eventsListData.titleTxt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Date: " + eventsListData.date[0] + '\n' +
                                        "Sign in: " + eventsListData.date[1].substring(0,eventsListData.date[1].length -3)  + '\n' +
                                        "Sign out: " + eventsListData.date[2].substring(0,eventsListData.date[2].length -3) + '\n'
                                      ,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.2,
                                        color: FitnessAppTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            eventsListData.fines != 0
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'P'+ eventsListData.fines.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, bottom: 3),
                                  child: Text(
                                    'Fines',
                                    style: TextStyle(
                                      fontFamily:
                                      FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.add,
                                  color: HexColor(eventsListData.endColor),
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                        NetworkImage(eventsListData.imagePath),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

