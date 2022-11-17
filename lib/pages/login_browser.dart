import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginOrBrowserPage extends StatelessWidget {
  LoginOrBrowserPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(
            top: false, bottom: false, child: _buildDetailed(context)));
  }

  Widget _buildDetailed(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage('assets/images/landing-page.jpg'),
                fit: BoxFit.cover)),
      ),
      Container(
        color: Colors.white.withOpacity(0.9),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 36),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Log in ',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 70,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                  ),
                ],
              ),
              textScaleFactor: 0.5,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 36),
                children: <TextSpan>[
                  TextSpan(text: 'or ', style: TextStyle(color: Colors.black)),
                ],
              ),
              textScaleFactor: 0.5,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 36),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Continue Browsing',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 60,
                          decoration: TextDecoration.underline))
                ],
              ),
              textScaleFactor: 0.5,
            )
          ],
        ),
      )
    ]);
  }
}
