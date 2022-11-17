import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:onedeal_app/model/car.dart';
import 'package:onedeal_app/model/new_reservation.dart';
import 'package:onedeal_app/services/reservation.dart';
import 'package:onedeal_app/util/formatter.dart';

import '../../data/local_data.dart';
import '../../model/user.dart';
import '../../util/widget_generator.dart';
import '../search/car_preview_row.dart';

class NewReservationPage extends StatefulWidget {
  final Car car;
  const NewReservationPage(this.car, {super.key});

  @override
  NewReservationPageState createState() => NewReservationPageState(car);
}

class NewReservationPageState extends State<NewReservationPage> {
  final Car car;
  double totalAmount = 0;

  late DateTime startDate;
  late DateTime endDate;

  int days = 0;

  bool isLoading = false;

  bool finishedSendingVal = false;

  var successful = false;

  var feedbackColor;

  String feedbackMsg = "";

  final ReservationService service = ReservationService();
  final DBHelper dbHelper = DBHelper();
  User? user;

  NewReservationPageState(this.car) {
    var now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day);
    endDate = startDate.add(const Duration(days: 3));
  }

  @override
  void initState() {
    super.initState();

    dbHelper.getUsers().then((result) {
      if (mounted) {
        setState(() {
          if (result.length == 1) {
            user = result[0];
            isLoading = false;
            _getData();
            recalculateAmount();
          } else {
            Navigator.popAndPushNamed(context, '/login');
          }
        });
      }
    });
  }

  _getData() async {
    // if (!isLoading) {
    //   if (this.mounted) {
    //     setState(() {
    //       isLoading = true;
    //     });
    //   }
    //   List<Future<ResponseResult>> requests = [
    //     service.fetchFeature(10, offset,
    //         selectedItem: selectedItem, isPremium: true),
    //     service.fetchFeature(20, allOtherOffset, selectedItem: selectedItem),
    //   ];
    //   if (!fetchedCategories) {
    //     requests.add(metadataService.fetchCategory());
    //   }

    //   List<ResponseResult> responses = await Future.wait(requests);

    //   if (responses[0].respondCode == 401 || responses[1].respondCode == 401) {
    //     Navigator.popAndPushNamed(context, '/login');
    //   }

    //   List<Car> tempList = [];
    //   offset += responses[0].transactions.length;
    //   for (int i = 0; i < responses[0].transactions.length; i++) {
    //     tempList.add(responses[0].transactions[i]);
    //   }

    //   if (this.mounted) {
    //     setState(() {
    //       isLoading = false;
    //       premiumCars.addAll(tempList);
    //       cars.addAll(allOtherCars);
    //       if (!fetchedCategories) {
    //         fetchedCategories = true;
    //         categories.addAll(tempCategories);
    //       }
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reservation",
              style: TextStyle(
                fontFamily: 'Opensans',
                // color: Color(0xFF6A6A6A),
              )),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        body: Stack(children: getItems(context)));
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createReservationView(context));

    if (isLoading) {
      var modal = Stack(
        children: [
          const Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
      widgets.add(modal);
    }

    if (finishedSendingVal) {
      var modal = Stack(
        children: [
          const Opacity(
            opacity: 0.9,
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ),
          Center(
            child: Column(children: [
              // const SizedBox(height: 100),
              FaIcon(
                  successful
                      ? FontAwesomeIcons.checkDouble
                      : FontAwesomeIcons.thumbsDown,
                  color: feedbackColor,
                  size: 60),
              const SizedBox(height: 10),
              Text(feedbackMsg,
                  style: const TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 30.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(successful);
                  },
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: const Center(
                        child: Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ))
            ]),
          ),
        ],
      );
      widgets.add(modal);
    }
    return widgets;
  }

  ListView createReservationView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarPreviewRow(car, true),
              // SearchRow(car),
              const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
                  child: Text("Dates",
                      style: TextStyle(
                          fontFamily: 'Opensans',
                          fontSize: 30.0,
                          color: Color(0xFF6A6A6A),
                          fontWeight: FontWeight.w600))),
              Row(children: [
                WidgetGenerator.getDateSelector(context, startDate, endDate,
                    (List<DateTime> date) {
                  startDate = date[0];
                  endDate = date[1];
                  recalculateAmount();
                }),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 10.0, top: 10.0),
                    child: Text(DateFormat.yMMMd().format(startDate),
                        style: TextStyle(
                            fontFamily: 'Opensans',
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600))),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 10.0, top: 10.0),
                    child: Text(DateFormat.yMMMd().format(endDate),
                        style: TextStyle(
                            fontFamily: 'Opensans',
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600))),
              ]),
              const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
                  child: Text("Amount",
                      style: TextStyle(
                          fontFamily: 'Opensans',
                          fontSize: 30.0,
                          color: Color(0xFF6A6A6A),
                          fontWeight: FontWeight.w600))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
                  child: Text(
                      "${Formatter.fromCent(totalAmount)} per day for $days day(s)",
                      style: TextStyle(
                          fontFamily: 'Opensans',
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
                  child: Text(Formatter.formatCurrent(totalAmount),
                      style: TextStyle(
                          fontFamily: 'Opensans',
                          fontSize: 30.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600))),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  // foregroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  var reservation = NewReservation.createNewReservation(
                      user != null ? user!.id : "",
                      car.id,
                      startDate,
                      startDate,
                      endDate,
                      totalAmount);
                  _submitForm(reservation);
                  setState(() {
                    isLoading = true;
                  });
                },
                child: const Text(
                  'Reserve Now',
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void showMessage(String message, bool succesful,
      [MaterialColor color = Colors.red]) {
    setState(() {
      isLoading = false;
      finishedSendingVal = true;
      successful = succesful;
      feedbackMsg = message;
      feedbackColor = Colors.red;
      if (succesful) {
        feedbackColor = Colors.green;
      }
    });
  }

  void _submitForm(NewReservation reservation) {
    print('Form save called, newContact is now up to date... $reservation');

    service.createReservation(reservation).then((value) async {
      if (value.respondCode == 200) {
        showMessage("successful created reservation id: ${value.res.id}", true,
            Colors.blue);
      } else {
        showMessage(
            "failed creating reservation contact support", false, Colors.red);
      }
    });
  }

  void recalculateAmount() {
    var difference = endDate.difference(startDate).inDays;
    setState(() {
      totalAmount = ((difference * car.price) / 100);
      days = difference;
    });
  }
}
