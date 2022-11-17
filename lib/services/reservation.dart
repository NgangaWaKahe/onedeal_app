import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:onedeal_app/model/new_reservation.dart';
import '../model/error_respond.dart';
import '../model/reservation.dart';
import '../model/reservation_filter.dart';
import '../model/results.dart';
import 'app.dart';

class ReservationService {
  var _headers = {'Content-Type': 'application/json'};

  Future<ResponseResult<Reservation>> fetchReservation(
      ReservationFilter filter, int limit, int offset,
      {String sortColor = "booking_date", String order = "desc"}) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();

      var queryParam = {"limit": limit.toString(), "offset": offset.toString()};
      queryParam["sort_column"] = filter.sort;
      queryParam["order"] = filter.order;
      if (filter.customerid != "") {
        queryParam["customer"] = filter.customerid;
      }

      final uri =
          Uri.https(AppService.ServiceUrl, "api/v1/reservation", queryParam);
      print(uri.toString());

      final response = await http.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        return ResponseResult.withRequest(
            [], response.statusCode, parseErrorRespond(response.body));
      }

      return ResponseResult<Reservation>(
          fromJson(response.body), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseResult<Reservation>(<Reservation>[], -1);
    }
  }

  static List<Reservation> fromJson(String returnJson) {
    Map<String, dynamic> map = json.decode(returnJson);
    var booking = <Reservation>[];

    if (map.containsKey('rows')) {
      var receivedRows = map['rows'];

      for (var x in receivedRows) {
        booking.add(Reservation.createBooking(x));
      }
    }

    return booking;
  }

  Future<ResponseSingleResult<Reservation>> createReservation(
      NewReservation reservation) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();
      final uri = Uri.https(AppService.ServiceUrl, "/api/v1/reservation");
      print(uri.toString());

      final response =
          await http.post(uri, headers: _headers, body: reservation.toJson());
      if (response.statusCode != 200) {
        return ResponseSingleResult<Reservation>(
            Reservation.empty(), response.statusCode);
      }
      return ResponseSingleResult<Reservation>(
          parseReservation(response.body), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseSingleResult<Reservation>(Reservation.empty(), -1);
    }
  }

  Reservation parseReservation(dynamic x) {
    return Reservation.createBooking(json.decode(x));
  }

  String parseErrorRespond(dynamic x) {
    var map = json.decode(x);
    return map["status"];
  }
}
