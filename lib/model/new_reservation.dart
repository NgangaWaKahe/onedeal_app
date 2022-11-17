import 'dart:convert';

import 'package:intl/intl.dart';

class NewReservation {
  String customerID;
  String carID;
  String reservationDate;
  String reservationStartDate;
  String reservationEndDate;
  double total;

  NewReservation(this.customerID, this.carID, this.reservationDate,
      this.reservationStartDate, this.reservationEndDate, this.total);

  @override
  String toString() {
    return "$customerID $carID $reservationDate $reservationStartDate $reservationEndDate $total";
  }

  String toJson() {
    var mapData = {};
    mapData["customer_id"] = customerID;
    mapData["car_id"] = carID;
    mapData["rental_date"] = reservationDate;
    mapData["rental_date_start_time"] = reservationStartDate;
    mapData["rental_date_end_time"] = reservationEndDate;
    mapData["cost"] = total;
    return json.encode(mapData);
  }

  static NewReservation createNewReservation(
      String customerID,
      String carID,
      DateTime reservationDate,
      DateTime reservationStartDate,
      DateTime reservationEndDate,
      double total) {
    final startFormatter = DateFormat('yyyy-MM-dd');
    final reservationDatesFormatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var covreservationDate = startFormatter.format(reservationDate);
    var startDate = reservationDatesFormatter.format(reservationStartDate);
    var endDate = reservationDatesFormatter.format(reservationEndDate);

    return NewReservation(
        customerID, carID, covreservationDate, startDate, endDate, total);
  }
}
