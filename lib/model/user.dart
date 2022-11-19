class User {
  String id = "";
  String firstName = "";
  String secondName = "";
  String city = "";
  String dob = "";
  int companyID = 0;
  String email = '';
  int isAdmin = 0;
  bool active = false;
  String password = '';
  String userType = '';
  String token = '';
  String phonenumber = '';
  String createDate = "";

  String toString() {
    return "id:$id name:$firstName email:$email userType:$userType";
  }
}
