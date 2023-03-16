import 'package:flutter/material.dart';
import 'package:onedeal_app/widgets/roundbutton.dart';
import 'package:onedeal_app/pages/signup.dart';

import 'login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28292E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 300.0,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/landing-page.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            height: 250.0,
                            color: Colors.white.withOpacity(0),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 110.0, 0.0, 0.0),
                            child: const Text('ONE',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                50.0, 175.0, 0.0, 0.0),
                            child: const Text('DEAL',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RoundedButton(
                "Log In",
                Colors.white12,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              RoundedButton(
                "Sign Up",
                Colors.white12,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
