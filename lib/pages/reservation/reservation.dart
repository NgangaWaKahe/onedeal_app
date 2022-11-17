import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/model/reservation.dart';
import 'package:onedeal_app/pages/reservation/reservation_thumbnail.dart';

import '../../data/local_data.dart';
import '../../model/reservation_filter.dart';
import '../../model/results.dart';
import '../../model/user.dart';
import '../../services/reservation.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  ReservationPageState createState() => ReservationPageState();
}

class ReservationPageState extends State<ReservationPage> {
  double totalAmount = 0;

  int days = 0;

  bool isLoading = false;

  var successful = false;

  String feedbackMsg = "";

  ScrollController _scrollController = ScrollController();
  final ReservationService service = ReservationService();
  final DBHelper dbHelper = DBHelper();
  User? user;

  int offset = 0;

  int limit = 20;

  List<Reservation> reservations = [];

  ReservationFilter filter = ReservationFilter.empty();

  String errorMsg = "";

  ReservationPageState();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("_getData");
        _getData();
      }
    });

    dbHelper.getUsers().then((result) {
      if (mounted) {
        setState(() {
          if (result.length == 1) {
            user = result[0];
            isLoading = false;
            filter.customerid = user!.id;
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

      List<ResponseResult> responses =
          await Future.wait([service.fetchReservation(filter, limit, offset)]);

      if (responses[0].respondCode == 401 || responses[0].respondCode == 401) {
        Navigator.popAndPushNamed(context, '/login');
      }

      List<Reservation> tempList = [];
      String tempErrorMsg = "";
      if (responses[0].respondCode == 200) {
        offset += responses[0].transactions.length;
        for (int i = 0; i < responses[0].transactions.length; i++) {
          tempList.add(responses[0].transactions[i]);
        }
      } else {
        tempErrorMsg = responses[0].requestType;
      }

      if (mounted) {
        setState(() {
          errorMsg = tempErrorMsg;
          isLoading = false;
          reservations.addAll(tempList);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reservation",
              style: TextStyle(fontFamily: 'Opensans')),
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
        children: const <Widget>[
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
      widgets.add(modal);
    }
    if (errorMsg != "") {
      var modal = Stack(
        children: const <Widget>[
          Opacity(
            opacity: 0.9,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: Text("unable to load data contact us",
                style: const TextStyle(
                    fontFamily: 'Opensans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      );
      widgets.add(modal);
    }
    return widgets;
  }

  Widget createReservationView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemCount: reservations.length,
            itemBuilder: (BuildContext context, int index) {
              return ReservationThumbnail(reservations[index]);
            },
          ),
        )
      ],
    );
  }
}
