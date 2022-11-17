import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/model/user.dart';
import 'package:onedeal_app/services/login.dart';

//https://codingwithjoe.com/building-forms-with-flutter/
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final User user = User();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _secondnameController = TextEditingController();
  final _cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final TextStyle styles =
      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void completeLogin(bool successful) {
    var message = "Successful registered";
    if (!successful) {
      message = "unable to register, try again later";
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
            SnackBar(backgroundColor: Colors.blueGrey, content: Text(message)))
        .closed
        .then((reason) {
      Navigator.popAndPushNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: new SafeArea(
            top: false,
            bottom: false,
            child: Container(
                height: screenHeight,
                width: screenWidth,
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/signup.jpg'),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        height: 250.0,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Positioned(
                          top: 110.0,
                          left: 30.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Register Now',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xFF312F2E),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'One Deal',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xFF312F2E),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 15.0),
                            ],
                          )),
                      Positioned(
                          top: 225.0,
                          child: Container(
                            height: screenHeight - 225.0,
                            width: screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.0),
                                    topRight: Radius.circular(40.0)),
                                color: Colors.white),
                            child: ListView(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        width: 150.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[],
                                        )),
                                  ],
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 30.0,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 36),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                'Create Account. Already have an account ',
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Color(0xFF312F2E),
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                          text: 'login ',
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.popAndPushNamed(
                                                  context, '/login');
                                            },
                                        ),
                                      ],
                                    ),
                                    textScaleFactor: 0.5,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: createInputDecorator('Email'),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'This field is required';
                                    }
                                    if (value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    if (!value.contains('@')) {
                                      return "A valid email should contain '@'";
                                    }
                                    if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                    ).hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                  },
                                ),
                                TextFormField(
                                    controller: _firstnameController,
                                    decoration:
                                        createInputDecorator('First Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                    }),
                                TextFormField(
                                    controller: _secondnameController,
                                    decoration:
                                        createInputDecorator('Second Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                    }),
                                TextFormField(
                                    controller: _cityController,
                                    decoration: createInputDecorator('City'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                    }),
                                TextFormField(
                                  controller: dateCtl,
                                  decoration:
                                      createInputDecorator('Date of birth'),
                                  onTap: () async {
                                    DateTime? date = DateTime(1900);
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());

                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      dateCtl.text = formatDate(
                                              date, [yyyy, '-', mm, "-", dd])
                                          .toString();
                                    }
                                  },
                                ),
                                SizedBox(height: 15.0),
                                GestureDetector(
                                    onTap: () {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      var user = new User();
                                      user.email = _usernameController.text;
                                      user.firstName =
                                          _firstnameController.text;
                                      user.secondName =
                                          _secondnameController.text;
                                      user.city = _cityController.text;
                                      user.dob = dateCtl.text;
                                      new LoginService().inviteUser(user).then(
                                          (onValue) => completeLogin(onValue));
                                    },
                                    child: Container(
                                      height: 40.0,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        shadowColor: Colors.greenAccent,
                                        color: Theme.of(context).primaryColor,
                                        elevation: 7.0,
                                        child: Center(
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ))
                    ],
                  ),
                ))));
  }

  InputDecoration createInputDecorator(String label) {
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor)));
  }
}
