import 'package:animated_background/fitness_app/Dashboard/event_list_view.dart';
import 'package:animated_background/fitness_app/models/events_list_data.dart';
import 'package:flutter/material.dart';

import '../fintness_app_theme.dart';
import 'shoes_store_page.dart';

class ShoesStoreDetailPage extends StatelessWidget {
  final EventsListData event;

  const ShoesStoreDetailPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -size.width / 2,
            right: -size.width / 3,
            width: size.width * 1.4,
            height: size.width * 1.4,
            child: Hero(
              tag: 'hero_background_${event.titleTxt}',
              child: Container(
                decoration: BoxDecoration(
                  color: event.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: kToolbarHeight + 20,
                child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      event.titleTxt,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: Material(
                          elevation: 10,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Color(0xFF5574b9),
                          )),
                          color: Color(0xFF5574b9),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.favorite_border),
                          ),
                        ),
                      ),
                    ]),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Hero(
                tag: 'hero_image_${event.titleTxt}',
                child: Image.network(
                  event.imagePath,
                  height: MediaQuery.of(context).size.width / 1.2,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Text("Date: " + event.date[0] + '\n' +
                  "Sign in: " + event.date[1].substring(0,event.date[1].length -3)  + '\n' +
                  "Sign out: " + event.date[2].substring(0,event.date[2].length -3) + '\n'
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
              ),
            ),
        ],
      ),
    );
  }
}
