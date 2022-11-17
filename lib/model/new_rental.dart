import 'dart:convert';

import 'package:intl/intl.dart';

class NewRental {
  String reservationID;

  NewRental(this.reservationID);

  @override
  String toString() {
    return reservationID;
  }

  String toJson() {
    var mapData = {};
    mapData["reservation_id"] = reservationID;
    return json.encode(mapData);
  }
}
