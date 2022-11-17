import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onedeal_app/model/category.dart';
import 'package:onedeal_app/model/results.dart';

import 'app.dart';

class CarMetadataService {
  final _headers = {'Content-Type': 'application/json'};

  Future<ResponseResult<Category>> fetchCategory() async {
    try {
      _headers["Authorization"] = await AppService.getUserToken();

      final uri =
          Uri.https(AppService.ServiceUrl, "api/v1/category", {"limit": "100"});
      print(uri.toString());

      final response = await http.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        return ResponseResult<Category>(<Category>[], response.statusCode);
      }

      return ResponseResult<Category>(
          fromJson(response.body), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseResult<Category>(<Category>[], -1);
    }
  }

  static List<Category> fromJson(String returnedJson) {
    Map<String, dynamic> map = json.decode(returnedJson);
    var res = <Category>[];
    if (map.containsKey('rows')) {
      for (var x in map["rows"]) {
        res.add(Category.retrieveCategory(x));
      }
    }
    return res;
  }
}
