import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onedeal_app/model/car.dart';
import 'package:onedeal_app/model/results.dart';
import 'package:onedeal_app/model/category.dart';

import 'app.dart';

class CarService {
  final _headers = {'Content-Type': 'application/json'};

  Future<ResponseSingleResult<Car>> getCar(String id) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();
      var queryParam = {"id": id.toString()};

      final uri =
          Uri.https(AppService.ServiceUrl, 'api/v1/car-search/$id', queryParam);
      print(uri.toString());

      final response = await http.get(uri, headers: _headers);
      print(response.statusCode);
      if (response.statusCode != 200) {
        return ResponseSingleResult<Car>(Car.empty(), response.statusCode);
      }

      return ResponseSingleResult<Car>(
          Car.retrieveCar(json.decode(response.body)), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseSingleResult<Car>(Car.empty(), -1);
    }
  }

  Future<ResponseResult<Car>> fetchFeature(int limit, int offset,
      {Category? selectedItem = null,
      bool isPremium = false,
      String searchTerm = ""}) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();

      var queryParam = {"offset": offset.toString(), "limit": limit.toString()};
      if (isPremium) {
        queryParam["is_premium"] = "1";
      }
      if (selectedItem != null) {
        queryParam["category"] = selectedItem.id;
      }
      if (searchTerm != "") {
        queryParam["search"] = searchTerm;
      }
      final uri =
          Uri.https(AppService.ServiceUrl, "api/v1/car/list", queryParam);
      print(uri.toString());

      final response = await http.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        return ResponseResult<Car>(<Car>[], response.statusCode);
      }

      return ResponseResult<Car>(fromJson(response.body), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseResult<Car>(<Car>[], -1);
    }
  }

  Future<ResponseResult<Car>> infiniteScroll(int limit, int offset) async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();

      var queryParam = {"offset": offset.toString(), "limit": limit.toString()};
      final uri =
          Uri.https(AppService.ServiceUrl, "api/v1/car/list", queryParam);
      print(uri.toString());

      final response = await http.get(uri, headers: _headers);
      print(uri.toString());
      if (response.statusCode != 200) {
        print("bad error happening ${response.statusCode}");
        return ResponseResult<Car>(<Car>[], response.statusCode);
      }

      return ResponseResult<Car>(fromJson(response.body), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseResult<Car>(<Car>[], -1);
    }
  }

  static List<Car> fromJson(String returnedJson) {
    Map<String, dynamic> map = json.decode(returnedJson);
    var res = <Car>[];
    if (map.containsKey('rows')) {
      for (var x in map["rows"]) {
        res.add(Car.retrieveCar(x));
      }
    }

    return res;
  }

  static double convertToDouble(dynamic val) {
    if (val is int) {
      return val.toDouble();
    }
    return val;
  }
}
