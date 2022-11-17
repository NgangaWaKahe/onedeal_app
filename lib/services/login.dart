import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onedeal_app/model/user.dart';

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

  // Future<ResponseResult<User>> fetchUses(int limit, int offset) async {
  //   try {
  //     _headers["Authorization"] = await AppService.getUserToken();
  //
  //     var queryParam = {"limit": limit.toString(), "offset": offset.toString()};
  //
  //     final uri = new Uri.https(AppService.ServiceUrl, "api/v1/company/admin/list", queryParam);
  //     print(uri.toString());
  //
  //     final response = await http.get(uri, headers: _headers);
  //     if (response.statusCode != 200) {
  //       return new ResponseResult(<User>[], response.statusCode);
  //     }
  //
  //     return new ResponseResult(fromJson(response.body), response.statusCode);
  //   } catch (e) {
  //     print(e);
  //     return new ResponseResult(<User>[], 500);
  //   }
  // }

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
    var user = new User();
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
    // user.phonenumber = map['phonenumber'];

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

  // Future<bool> createNewUser(User user, Company company) async {
  //   try {
  //     final String json = _toRegistrationJson(user, company);
  //     _headers["Authorization"] = await AppService.getUserToken();
  //
  //     final uri = new Uri.https(AppService.ServiceUrl, "/api/v2/registration/new");
  //     final response =
  //     await http.post(uri, headers: _headers, body: json);
  //     if (response.statusCode != 200) {
  //       return false;
  //     }
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  // String _toRegistrationJson(User user, Company company) {
  //   var mapData = new Map();
  //   mapData["name"] = company.name;
  //   mapData["address"] = company.address;
  //   mapData["sector"] = company.sector;
  //   mapData["kra_id"] = company.registration;
  //
  //   var userData = new Map();
  //   userData["firstname"] = user.firstName;
  //   userData["email"] = user.email;
  //   userData["city"] = "";
  //   userData["dob"] = user.dob;
  //   userData["idnumber"] = "";
  //   userData["password"] = user.password;
  //   userData["phonenumber"] = "";
  //
  //   var data = new Map();
  //   data["company"] = mapData;
  //   data["user"] = userData;
  //
  //   String jsonString = json.encode(data);
  //   print(jsonString);
  //   return jsonString;
  // }

  // Future<bool> updatePassword(String oldPassword, String newPassword) async {
  //   try {
  //     var data = new Map();
  //     data["old_password"] = oldPassword;
  //     data["new_password"] = newPassword;
  //     final String body = json.encode(data);
  //
  //     _headers["Authorization"] = await AppService.getUserToken();
  //
  //     final uri = new Uri.https(AppService.ServiceUrl, "api/v2/update-password");
  //     print(uri);
  //     final response =
  //     await http.post(uri, headers: _headers, body: body);
  //     print(response.statusCode);
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

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
}
