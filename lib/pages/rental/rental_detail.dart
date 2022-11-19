import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:onedeal_app/model/new_rental.dart';

import '../../data/local_data.dart';
import '../../model/car.dart';
import '../../model/rental.dart';
import '../../model/reservation.dart';
import '../../model/results.dart';
import '../../services/car.dart';
import '../../services/rental.dart';
import '../../util/formatter.dart';
import '../../util/widget_generator.dart';
import '../action_screen.dart';
import '../loading_screen.dart';
import '../search/car_preview_row.dart';

class RentalDetailPage extends StatefulWidget {
  final Rental rental;

  const RentalDetailPage(this.rental, {super.key});

  @override
  RentalDetailPageState createState() => RentalDetailPageState(rental);
}

class RentalDetailPageState extends State<RentalDetailPage>
    with SingleTickerProviderStateMixin {
  final Rental rental;
  final DBHelper dbHelper = DBHelper();
  final CarService service = CarService();
  final RentalService rservice = RentalService();

  Car? car;
  bool isLoading = false;

  bool finishedSendingVal = false;

  String feedbackMsg = "";

  bool successful = false;

  Color feedbackColor = Colors.black;

  RentalDetailPageState(this.rental);

  @override
  void initState() {
    super.initState();

    dbHelper.getUsers().then((result) {
      if (mounted) {
        setState(() {
          if (result.length == 1) {
            isLoading = false;
            _getData();
          } else {
            Navigator.popAndPushNamed(context, '/login');
          }
        });
      }
    });
  }

  _getData() async {
    if (!isLoading) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      List<ResponseSingleResult<Car>> responses =
          await Future.wait([service.getCar(rental.carID)]);

      if (responses[0].respondCode == 401) {
        Navigator.popAndPushNamed(context, '/login');
      }

      Car temp = responses[0].res;

      if (mounted) {
        setState(() {
          isLoading = false;
          car = temp;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Rental Detail",
              style: TextStyle(
                  fontFamily: 'Opensans', fontWeight: FontWeight.w600))),
      body: SafeArea(child: Stack(children: getItems(context))),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createReservationDetailsView(context));

    if (isLoading) {
      widgets.add(const LoadingScreen());
    }

    if (finishedSendingVal) {
      widgets.add(ActionRespondScreen(successful, feedbackColor, feedbackMsg));
    }

    return widgets;
  }

  ListView createReservationDetailsView(BuildContext context) {
    // print(reservation.id);
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WidgetGenerator.showDetailMinorAttribute(
                  context, "Brand", rental.carBrand),
              WidgetGenerator.showDetailMinorAttribute(
                  context, "Make", rental.carMake),
              car != null ? CarPreviewRow(car!, false) : const SizedBox(),
              WidgetGenerator.showDetailMinorAttribute(
                  context, "Amount", Formatter.formatCurrent(rental.cost)),
              WidgetGenerator.showDetailMinorAttribute(context, "Rental Start",
                  DateFormat.yMMMd().format(rental.reservationStartDate)),
              WidgetGenerator.showDetailMinorAttribute(context, "Rental End",
                  DateFormat.yMMMd().format(rental.reservationEndDate)),
              WidgetGenerator.showDetailMinorAttribute(
                  context, "Rental Status", rental.status),
              // reservation.isAccepted()
              //     ? WidgetGenerator.showActionPanel(context, "Action", onSecure)
              //     : const SizedBox(width: 0)
            ],
          ),
        ),
      ],
    );
  }

  // onSecure() {
  //   print("clicked");

  //   var newRental = NewRental(reservation.id);
  //   _submitForm(newRental);
  // }

  void showMessage(String message, bool succesful,
      [MaterialColor color = Colors.red]) {
    setState(() {
      isLoading = false;
      finishedSendingVal = true;
      successful = succesful;
      feedbackMsg = message;
      feedbackColor = succesful ? Colors.green : Colors.red;
    });
  }

  void _submitForm(NewRental rental) {
    print('Form save called, newContact is now up to date... $rental');

    rservice.createRental(rental).then((value) async {
      if (value.respondCode == 200) {
        var msg = "successful created rental id: ${value.res.id}";
        showMessage(msg, true, Colors.blue);
      } else {
        var msg = "failed creating rental contact support";
        showMessage(msg, false, Colors.red);
      }
    });
  }
}
