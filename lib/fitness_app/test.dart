import 'dart:convert';
import 'package:animated_background/src/api/api.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'fintness_app_theme.dart';
import 'models/events_list_data.dart';

class ListDisplay extends StatefulWidget {
  @override
  const ListDisplay({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  State createState() => new DyanmicList();
}
class DyanmicList extends State<ListDisplay>  with TickerProviderStateMixin{
  List<Widget> litems = [];
  int tag =0;
  double topBarOpacity = 0.0;
  Animation<double> topBarAnimation;
  AnimationController animationController;
  final ScrollController scrollController = ScrollController();
  List<String> options = [
    'All', 'Event\'s Today', 'Event\'s Done', 'Incoming Events'
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
                                  'Events',
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
    var length = eventsListData.length;
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: new Stack(
            children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top + 15,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) => setState(() => {tag = val,loadEvents=getEvents()}),
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),),),
              getAppBarUI(),
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
          )
      ),
    );
  }
  Future loadEvents;
  Future getEvents() async{
    eventsListData.clear();
    var response ;
    if (tag == 1)
    {
      response =  await CallApi().getData('getEventToday');
    }
    else if(tag == 3)
    {
      response =  await CallApi().getData('getIncomingToday');
    }
    else if(tag == 2)
    {
      response =  await CallApi().getData('getDoneToday');
    }
    else
    {
      response =  await CallApi().getData('getEvents');
    }
    var event = json.decode(response.body);
    print("Event: $event");
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

    return true;
  }
  List<EventsListData> eventsListData = [];
  Widget EventsLoad()
  {
      return FutureBuilder(
          future: loadEvents,
          builder: (context,snapshot){
            print(snapshot);
                if(ConnectionState.done == snapshot.connectionState) {
                  if(eventsListData.length>=1)
                    {
                      return ListView.builder(
                          itemCount: eventsListData.length,
                          // Provide a builder function. This is where the magic happens.
                          // Convert each item into a widget based on the type of item it is.
                          itemBuilder: (context, index) {
                            final item = eventsListData[index];
                            return GFCard(
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