import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/data/local_data.dart';
import 'package:onedeal_app/model/user.dart';
import 'package:onedeal_app/services/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DBHelper dbHelper = DBHelper();

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: color, content: const Text("Login failed")));
  }

  void completeLogin(User? user) {
    if (user == null) {
      showMessage('Username or password does not match', Colors.red);
    } else {
      dbHelper.deleteUser();

      dbHelper.saveUser(user).then((onValue) {
        Navigator.popAndPushNamed(context, '/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/landing-page.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    height: 250.0,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: const Text('ONE',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(50.0, 175.0, 0.0, 0.0),
                    child: const Text('DEAL',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autocorrect: false,
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor))),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      autocorrect: false,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor))),
                      obscureText: true,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      alignment: const Alignment(1.0, 0.0),
                      padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    GestureDetector(
                        onTap: () {
                          var user = User();
                          user.email = _usernameController.text;
                          user.password = _passwordController.text;
                          LoginService()
                              .createLogin(user)
                              .then((onValue) => completeLogin(onValue));
                        },
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Theme.of(context).primaryColor,
                            elevation: 7.0,
                            child: const Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                // Center(
                                //   child:
                                //   ImageIcon(),
                                // ),
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text('Register',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                )),
            const SizedBox(height: 15.0),
          ],
        ));
  }
}
