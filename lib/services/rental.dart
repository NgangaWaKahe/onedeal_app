import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/new_rental.dart';
import '../model/rental.dart';
import '../model/reservation_filter.dart';
import '../model/results.dart';
import 'app.dart';

class RentalService {
  var _headers = {'Content-Type': 'application/json'};

  Future<ResponseResult<Rental>> fetchRental(
      ReservationFilter filter, int limit, int offset) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();

      var queryParam = {"limit": limit.toString(), "offset": offset.toString()};
      queryParam["sort_column"] = filter.sort;
      queryParam["order"] = filter.order;
      if (filter.customerid != "") {
        queryParam["customer"] = filter.customerid;
      }

      final uri = Uri.https(AppService.ServiceUrl, "api/v1/rental", queryParam);
      print(uri.toString());

      final response = await http.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        return ResponseResult<Rental>(<Rental>[], response.statusCode);
      }

      return ResponseResult<Rental>(
          fromJson(response.body), response.statusCode);
    } catch (e) {
      return ResponseResult<Rental>(<Rental>[], -1);
    }
  }

  static List<Rental> fromJson(String returnJson) {
    Map<String, dynamic> map = json.decode(returnJson);
    var rentals = <Rental>[];

    if (map.containsKey('rows')) {
      var receivedRows = map['rows'];

      for (var x in receivedRows) {
        rentals.add(Rental.createRental(x));
      }
    }

    return rentals;
  }

  Future<ResponseSingleResult<Rental>> createRental(NewRental newRental) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();
      final uri = Uri.https(AppService.ServiceUrl, "/api/v1/rental");
      print(uri.toString());

      final response =
          await http.post(uri, headers: _headers, body: newRental.toJson());
      if (response.statusCode != 200) {
        return ResponseSingleResult<Rental>(
            Rental.empty(), response.statusCode);
      }
      return ResponseSingleResult<Rental>(
          parseRental(response.body), response.statusCode);
    } catch (e) {
      return ResponseSingleResult<Rental>(Rental.empty(), -1);
    }
  }

  Rental parseRental(dynamic x) {
    return Rental.createRental(json.decode(x));
  }
}
