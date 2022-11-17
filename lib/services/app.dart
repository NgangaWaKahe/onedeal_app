import 'package:intl/intl.dart';
import 'package:onedeal_app/data/local_data.dart';
import 'package:onedeal_app/model/user.dart';

class AppService {
  static const ServiceUrlLogin =
      'https://onedeal.runbit.co.uk/api/v1/tkn/login';
  static const ServiceUrl = 'onedeal.runbit.co.uk';
  static const ServiceImageURL = 'https://onedeal.runbit.co.uk/api/v1/images';

  static const Header = {'Content-Type': 'application/json'};
  static DateFormat formatFilter = DateFormat('yyyy-MM-dd');
  static DateFormat dateFormat = DateFormat("y-MM-dTHH:mm:ss");
  static DateFormat dateFormatBasic = DateFormat("y-MM-d");

  static Future<String> getUserToken() async {
    final DBHelper dbHelper = DBHelper();
    List<User> users = await dbHelper.getUsers();

    if (users.isEmpty) {
      return "";
    }
    return users[0].token;
  }

  static String formatDate(DateTime datetime) {
    return formatFilter.format(datetime);
  }
}
