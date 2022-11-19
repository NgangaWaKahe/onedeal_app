import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onedeal_app/model/user.dart';

import '../model/error_respond.dart';
import '../model/results.dart';
import 'app.dart';

class LoginService {
  Future<User?> createLogin(User user) async {
    try {
      String json = _toJson(user);
      final uri = Uri.https(AppService.ServiceUrl, "api/v1/tkn/login");
      final response =
          await http.post(uri, headers: AppService.Header, body: json);
      print(response.statusCode);
      if (response.statusCode != 200) {
        return null;
      }
      return _fromJson(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseResult<String>> findDocument() async {
    try {
      var _headers = {'Content-Type': 'application/json'};
      _headers["Authorization"] = await AppService.getUserToken();
      final uri = Uri.https(AppService.ServiceUrl, "api/v1/documents-name");
      final response = await http.get(uri, headers: _headers);
      print(response.statusCode);
      if (response.statusCode != 200) {
        return ResponseResult([], response.statusCode);
      }
      return ResponseResult(
          parseDocumentList(response.body), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseResult([], -1);
    }
  }

  Future<User?> register(User user) async {
    try {
      String json = _toJson(user);
      final uri = new Uri.https(AppService.ServiceUrl, "api/v1/tkn/login");
      final response =
          await http.post(uri, headers: AppService.Header, body: json);
      print(response.statusCode);
      if (response.statusCode != 200) {
        return null;
      }
      return _fromJson(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<bool> updateUserActiveStatus(String username, bool active, int companyID) async {
  //   try {
  //     _headers["Authorization"] = await AppService.getUserToken();
  //
  //     final uri = new Uri.https(AppService.ServiceUrl, "api/v1/company/admin/update");
  //     print(uri.toString());
  //     print(companyID);
  //
  //     var mapData = new Map();
  //     mapData["email"] = username;
  //     mapData["companyid"] = companyID;
  //     mapData["active"] = active;
  //
  //     final response = await http.post(uri, headers: _headers, body: json.encode(mapData));
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  List<String> parseDocumentList(String returnJson) {
    List<dynamic> map = json.decode(returnJson);
    var paths = <String>[];
    for (var a in map) {
      var host = AppService.serviceDocumentURL;
      paths.add("$host?name=$a");
    }

    return paths;
  }

  List<User> fromJson(String returnJson) {
    Map<String, dynamic> map = json.decode(returnJson);
    var users = <User>[];

    if (map.containsKey('rows')) {
      var receivedRows = map['rows'];

      for (var x in receivedRows) {
        var user = User();
        user.id = x['id'];
        user.firstName = x['firstname'];
        user.email = x['email'];
        user.isAdmin = 0;
        user.token = x['token'];
        user.city = x['city'];
        user.dob = x['dob'];
        user.userType = x['users_type'];
        user.active = x['active'];
        if (x['is_admin']) {
          user.isAdmin = 1;
        }
        users.add(user);
      }
    }

    return users;
  }

  User _fromJson(String jsonString) {
    Map<String, dynamic> map = json.decode(jsonString);
    var user = User();
    user.id = map['id'];
    user.firstName = map['first_name'];
    user.secondName = map['second_name'];
    user.email = map['email'];
    user.isAdmin = 0;
    user.token = map['token'];
    user.city = map['city'];
    user.dob = map['dob'];
    user.active = map['active'];
    user.userType = map['users_type'];
    user.phonenumber = map['phonenumber'];
    user.createDate = map['create_date'];
    // if (map['is_admin']) {
    //   user.isAdmin = 1;
    // }
    return user;
  }

  String _toJson(User task) {
    var mapData = {};
    mapData["email"] = task.email;
    mapData["password"] = task.password;
    String jsonString = json.encode(mapData);
    return jsonString;
  }

  Future<bool> inviteUser(User user) async {
    try {
      var data = new Map();
      data["second_name"] = user.secondName;
      data["first_name"] = user.firstName;
      data["email"] = user.email;
      data["city"] = user.city;
      data["dob"] = user.dob;
      data["idnumber"] = "";
      data["password"] = "";
      data["phonenumber"] = "";
      final String body = json.encode(data);

      final uri = new Uri.https(AppService.ServiceUrl, "api/v2/invite");
      print(uri);
      final response =
          await http.post(uri, headers: AppService.Header, body: body);
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ResponseSingleResult<UploadRespond>> uploadPhotos(
      List<String> paths) async {
    try {
      Map<String, String> headers = {};
      headers["Authorization"] = await AppService.getUserToken();
      final uri = Uri.https(AppService.ServiceUrl, "api/v1/document");
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = await AppService.getUserToken();
      for (String path in paths) {
        request.files.add(await http.MultipartFile.fromPath('files', path));
      }

      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();

      print(response.statusCode);
      if (response.statusCode == 200) {
        return ResponseSingleResult<UploadRespond>(
            parseErrorRespond(respStr), response.statusCode);
      }
      return ResponseSingleResult<UploadRespond>(
          UploadRespond.empty(), response.statusCode);
    } catch (e) {
      print(e);
      return ResponseSingleResult<UploadRespond>(UploadRespond.empty(), -1);
    }
  }

  UploadRespond parseErrorRespond(dynamic x) {
    var map = json.decode(x);
    return UploadRespond.parseRespond(map);
  }
}
