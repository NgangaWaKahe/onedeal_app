import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/model/car.dart';
import 'package:onedeal_app/data/local_data.dart';
import 'package:onedeal_app/model/car.dart';

import '../../util/formatter.dart';
import '../../util/icon_generator.dart';
import '../../util/widget_generator.dart';
import '../login_browser.dart';
import '../newreservation/new_reservation.dart';

class DetailPage extends StatefulWidget {
  final Car car;

  const DetailPage(this.car, {super.key});

  @override
  _DetailPageState createState() => _DetailPageState(car);
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  final Car car;

  _DetailPageState(this.car);

  TabController? tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Car details",
            style: TextStyle(
                fontFamily: 'Opensans',
                // color: Color(0xFF6A6A6A),
                fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Container(
                  height: 300.0,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      viewportFraction: 1,
                      // enlargeCenterPage: true,
                      // enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    ),
                    items: getImage(),
                  ))),
          Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 1.0),
              child: Text("${car.brand} - ${car.make}",
                  style: const TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 15.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600))),
          const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
              child: Text("Details",
                  style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 30.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600))),
          WidgetGenerator.showMinorAttribute(
              context, "Transmission", car.transmission),
          WidgetGenerator.showMinorAttribute(context, "Engine", car.engineType),
          WidgetGenerator.showMinorAttribute(
              context, "Engine Size", car.engineSize.toString()),
          WidgetGenerator.showMinorAttribute(
              context, "Capacity", car.capacity.toString()),
          WidgetGenerator.showMinorAttribute(context, "Color", car.color),
          const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
              child: Text("Features",
                  style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 30.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600))),
          Container(
              height: 120.0,
              child: ListView.builder(
                  itemCount: car.carFeature.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          IconGenerator.getCarFeatureIcon(
                              context, car.carFeature[index].name),
                          Text(car.carFeature[index].name,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center)
                        ],
                      ),
                    );
                  }))
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          dbHelper.getUsers().then((users) {
            if (users.isEmpty) {
              Navigator.of(context).push(MaterialPageRoute<bool>(
                  builder: (BuildContext context) {
                    return LoginOrBrowserPage();
                  },
                  fullscreenDialog: true));
            } else {
              Navigator.of(context).push(MaterialPageRoute<bool>(
                  builder: (BuildContext context) {
                    return NewReservationPage(car);
                  },
                  fullscreenDialog: true));
            }
          });
        },
        icon: const Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
          size: 29,
        ),
        label: Text('Book Now ${Formatter.fromCent(car.price)}',
            style: const TextStyle(
                fontFamily: 'Opensans',
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Book',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Widget> getImage() {
    return car.imageUrl
        .map((item) => Container(
              height: 300.0,
              child: CachedNetworkImage(
                imageUrl: item,
                imageBuilder: (context, imageProvider) => Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ))
        .toList();
  }
}
