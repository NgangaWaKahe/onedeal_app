import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onedeal_app/pages/loading_screen.dart';

import '../../data/local_data.dart';
import 'basic_information.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  final DBHelper dbHelper = DBHelper();

  List<Options> actions = [
    Options("Person information", const FaIcon(FontAwesomeIcons.personBooth)),
    Options("Payments", const FaIcon(FontAwesomeIcons.creditCard)),
    Options("Support", const FaIcon(FontAwesomeIcons.questionCircle)),
    Options("Feedback", const FaIcon(FontAwesomeIcons.commentDots)),
    Options("Legal", const FaIcon(FontAwesomeIcons.balanceScaleLeft)),
    Options("Terms of Service", const FaIcon(FontAwesomeIcons.fileContract)),
    Options("Log out", const FaIcon(FontAwesomeIcons.signOutAlt))
  ];

  @override
  initState() {
    super.initState();
    dbHelper.getUsers().then((value) => {
          if (value.isEmpty) {Navigator.popAndPushNamed(context, '/login')}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor),
      body: SafeArea(child: Stack(children: getItems(context))),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createListView(context));

    if (isLoading) {
      widgets.add(const LoadingScreen());
    }

    return widgets;
  }

  Widget createListView(BuildContext context) {
    return ListView.separated(
      itemCount: actions.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
            child: ListTile(
              leading: actions[index].icon,
              title: Text(
                actions[index].title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              onClick(actions[index].title);
            });
      },
    );
  }

  onClick(String action) {
    if (action == actions[0].title) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const BasicInformationPage()));
    } else if (action == actions[6].title) {
      dbHelper.deleteUser().then((onValue) {
        Navigator.popAndPushNamed(context, '/welcome');
      });
    }
  }

  Widget createTitle(String title) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                  child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ))
            ]),
          ],
        ));
  }
}

class Options {
  final String title;
  final Widget icon;

  Options(this.title, this.icon);
}
