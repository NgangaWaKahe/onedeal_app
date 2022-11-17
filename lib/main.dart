import 'package:flutter/material.dart';
import 'package:onedeal_app/pages/reservation/reservation.dart';
import 'package:onedeal_app/pages/rental/rental.dart';
import 'package:onedeal_app/pages/home/home.dart';
import 'package:onedeal_app/pages/login.dart';
import 'package:onedeal_app/pages/profile/profile.dart';
import 'package:onedeal_app/pages/signup.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "One Deal discover rental cars",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: const Color(0xFF116D51),
        accentColor: Colors.grey,
        // Define the default Font Family
        fontFamily: 'Quicksand',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline5: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0),
          bodyText1: TextStyle(fontSize: 14.0),
        ),
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MainPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? controller;
  // final DBHelper dbHelper = new DBHelper();
  bool isAdmin = false;

  @override
  void initState() {
    controller = new TabController(initialIndex: 0, length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          // Add tabs as widgets
          children: getPages(),
          // set the controller
          controller: controller,
        ), // new
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          // color: Theme.of(context).primaryColor,
          color: Colors.white,
          child: Container(
            // height: 50.0,
            child: TabBar(
              controller: controller,
              unselectedLabelColor: Colors.black,
              labelColor: Theme.of(context).primaryColor,
              tabs: getTabs(),
            ),
          ),
        ));
  }

  List<Widget> getPages() {
    return <Widget>[
      const HomePage(),
      const ReservationPage(),
      const RentalPage(),
      const ProfilePage()
    ];
  }

  List<Widget> getTabs() {
    List<Widget> widget = <Widget>[
      const Tab(icon: Icon(Icons.search, size: 30)),
      const Tab(icon: Icon(Icons.book_sharp, size: 30)),
      const Tab(icon: Icon(Icons.airport_shuttle, size: 30)),
      const Tab(icon: Icon(Icons.account_circle_sharp, size: 30)),
    ];
    return widget;
  }
}
