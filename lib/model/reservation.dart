import 'dart:convert';

import 'package:intl/intl.dart';

import '../services/app.dart';
import '../util/formatter.dart';

class Reservation {
  String id = "";
  DateTime reservationDate = DateTime.now();
  DateTime reservationStartDate = DateTime.now();
  DateTime reservationEndDate = DateTime.now();

  String carID = "";
  String carPlateNumber = "";
  String carBrand = "";
  String carMake = "";
  String carCategory = "";
  String customerID = "";
  String customerEmail = "";
  String customerNames = "";
  double cost = 0;
  String status = "";
  DateTime createdTime = DateTime.now();
  List<String> images = [];
  Reservation.empty();

  Reservation(
      this.id,
      this.reservationDate,
      this.reservationStartDate,
      this.reservationEndDate,
      this.carID,
      this.carPlateNumber,
      this.carBrand,
      this.carMake,
      this.carCategory,
      this.customerID,
      this.customerEmail,
      this.customerNames,
      this.cost,
      this.status,
      this.createdTime,
      this.images);

  bool isAccepted() {
    return status == "accepted";
  }

  static Reservation createBooking(dynamic map) {
    List<String> images = [];
    for (var w in map["images"]) {
      var host = AppService.ServiceImageURL;
      var url = "$host?name=$w";
      images.add(url);
    }
    return Reservation(
        map["id"],
        AppService.dateFormatBasic.parse(map["rental_date"]),
        AppService.dateFormat.parse(map["rental_date_start_time"]),
        AppService.dateFormat.parse(map["rental_date_end_time"]),
        map["car_id"],
        map["car_plate_number"],
        map["car_brand"],
        map["car_make"],
        map["car_category"],
        map["customer_id"],
        map["customer_email"],
        map["customer_names"],
        Formatter.convertToDouble(map["cost"]),
        map["reservation_status"],
        AppService.dateFormat.parse(map["create_date"]),
        images);
  }
}
