import 'dart:convert';
import 'dart:ui';

import 'package:animated_background/fitness_app/models/events_list_data.dart';
import 'package:animated_background/src/api/api.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'shoes_store_detail_page.dart';
import 'package:vector_math/vector_math.dart' as vector;

const bottomBackgroundColor = Color(0xFFF1F2F7);
const Options = ['All', 'Incoming', 'Done', 'Today'];
const marginSide = 14.0;
const leftItemSeparator = const SizedBox(
  width: 30,
);


class ShoesStorePage extends StatefulWidget {
  @override
  _ShoesStorePageState createState() => _ShoesStorePageState();
}

class _ShoesStorePageState extends State<ShoesStorePage> {
  final _pageController = PageController(viewportFraction: 0.78);
  final _pageNotifier = ValueNotifier(0.0);
  String selected;
  List<EventsListData> _categorize= null;




  void _listener() {
    _pageNotifier.value = _pageController.page;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.addListener(_listener);
    });
    loadEvents=getEvents();
    selected="All";
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }
  Future loadEvents;
  Future getEvents() async{
    eventsListData.clear();

    var response ;
    if (selected == "Today")
    {
      response =  await CallApi().getData('getEventToday');
    }
    else if(selected == 'Incoming')
    {
      response =  await CallApi().getData('getIncomingToday');
    }
    else if(selected == 'Done')
    {
      response =  await CallApi().getData('getDoneToday');
    }
    else
    {
      response =  await CallApi().getData('getEvents');
    }
    var event = json.decode(response.body);
    int counter = 1 ;
    String imagePath = 'assets/fitness_app/breakfast.png';
    String titleTxt="Breakfast";
    String startColor = '#FA7D82';
    String endColor='#FA7D82';
    Color color;
    List<String> date=<String>['Bread,', 'Peanut butter,', 'Apple'];
    final String _url ='https://ssc.codes/storage/';
    int fines=0;
    for(var u in event) {
      if(counter == 1)
        {
            color=Color(0xFF5574b9);
        }
      else if(counter == 2)
        {
            color=Color(0xFF52b8c3);
        }
      else if(counter == 3)
      {
          color=Color(0xFFE3AD9B);
      }
      else if(counter == 4)
      {
          color = Color(0xFF444547);
          counter= 0;
      }
      counter++;
      titleTxt = u['title'];
      fines =u['fines'];
      date = <String>[u['date'],u['start_time'],u['end_time']];
      EventsListData data = EventsListData(_url +  u['image'], titleTxt, fines, date, startColor, endColor,color: color);
      eventsListData.add(data);

    }

    return true;
  }
  List<EventsListData> eventsListData = [];

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),

              const SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Options.length,
              itemBuilder: (_, index) =>
                  Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          selected = Options[index];
                          loadEvents=getEvents();
                        });
                      },
                      child: Text(
                        Options[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Options[index] == selected ? Colors.black : Colors.grey[400],
                          fontSize: 17,
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildLeftItem(String title, bool selected) =>

        new InkWell(
          onTap: () {
            Navigator.pushNamed(context, "YourRoute");
          },
          child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.black : Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        );


    final size = MediaQuery.of(context).size;
    const marginCenter = EdgeInsets.symmetric(horizontal: 50, vertical: 15);

    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(left: marginSide +40 ,right: marginSide,bottom: size.height * 0.15 ,top : size.height * 0.02),
            child: _buildHeader(),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: -10,
                  height: size.height * 0.50,
                  child: FutureBuilder(
                    future: loadEvents,
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        if(eventsListData.length >=1){

                          if(_pageController.hasClients)
                            {
                              print("Have Client");
                            }
                          else
                            {
                              _pageNotifier.value = 0.0;
                            }

                          return PageView.builder(
                              controller: _pageController,
                              itemCount: eventsListData.length,
                              itemBuilder: (context, index) {
                                print("INDEX: $index");
                                print("Page Notifier: " + _pageNotifier.value.toString());

                                double x = 0;
                                final t = (index - _pageNotifier.value);
                                print("T: $t");
                                final rotationY = lerpDouble(0, 90, t);
                                final translationX = lerpDouble(0, -50, t);
                                final scale = lerpDouble(0, -0.2, t);
                                final translationXShoes = lerpDouble(0, 150, t);
                                final rotationShoe = lerpDouble(0, -45, t);
                                final transform = Matrix4.identity();
                                transform.translate(translationX);
                                transform.setEntry(3, 2, 0.001);
                                transform.scale(1 - scale);
                                transform.rotateY(vector.radians(rotationY));
                                final item=eventsListData[index];
                                final transformShoe = Matrix4.identity();
                                transformShoe.translate(translationXShoes);
                                transformShoe.rotateZ(vector.radians(rotationShoe));
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                        transitionDuration:
                                        const Duration(milliseconds: 800),
                                        pageBuilder: (_, animation, __) =>
                                            FadeTransition(
                                              opacity: animation,
                                              child: ShoesStoreDetailPage(
                                                event: item,
                                              ),
                                            ),
                                      ));
                                    },
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: [
                                        Transform(
                                          alignment: Alignment.center,
                                          transform: transform,
                                          child: Stack(
                                            children: [
                                              Hero(
                                                tag:
                                                'hero_background_${item.titleTxt}',
                                                child: Card(
                                                  elevation: 6,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                  ),
                                                  margin: marginCenter,
                                                  color: item.color,
                                                  child: const SizedBox.expand(),
                                                ),
                                              ),
                                              Container(
                                                margin: marginCenter,
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          item.titleTxt,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.favorite_border,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Php ${item.fines}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: transformShoe,
                                            child: Hero(
                                              tag: 'hero_image_${item.titleTxt}',
                                              child: Image.network(
                                                item.imagePath,
                                                height: size.width / 2.5,
                                                width: size.width,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        else
                          {
                            return EmptyListWidget(
                                title: 'No Events',
                                subTitle: 'No  Events available yet',
                                image: 'lib/resources/images/im_emptyIcon_2.png',
                                titleTextStyle: Theme.of(context).typography.dense.headline4.copyWith(color: Color(0xff9da9c7)),
                                subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6))
                            );
                          }
                      }
                      else{
                        return SpinKitCircle(color: Colors.blue,);
                      }
                    }
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
