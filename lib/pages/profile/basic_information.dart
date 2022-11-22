import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onedeal_app/pages/loading_screen.dart';
import 'package:onedeal_app/pages/uploaddoc/view_document.dart';
import '../../data/local_data.dart';
import '../../model/user.dart';
import '../../services/app.dart';
import '../../util/widget_generator.dart';
import '../../widgets/buttons.dart';
import '../uploaddoc/upload_document.dart';

class BasicInformationPage extends StatefulWidget {
  const BasicInformationPage({super.key});

  @override
  _BasicInformationPageState createState() {
    return _BasicInformationPageState();
  }
}

class _BasicInformationPageState extends State<BasicInformationPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  final DBHelper dbHelper = DBHelper();

  User? user;

  @override
  initState() {
    super.initState();

    dbHelper.getUsers().then((result) {
      if (mounted) {
        setState(() {
          if (result.length == 1) {
            user = result[0];
            isLoading = false;
          } else {
            Navigator.popAndPushNamed(context, '/login');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text("Basic Information",
              style: TextStyle(
                  fontFamily: 'Opensans', fontWeight: FontWeight.w600)),
          backgroundColor: Theme.of(context).primaryColor),
      body: SafeArea(child: Stack(children: getItems(context))),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    if (!isLoading) {
      widgets.add(createListView(context));
    }
    if (isLoading) {
      widgets.add(const LoadingScreen());
    }

    return widgets;
  }

  Widget createListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetGenerator.showDetailMinorAttribute(
            context, "Names", user!.firstName + " " + user!.secondName),
        WidgetGenerator.showDetailMinorAttribute(context, "Email", user!.email),
        WidgetGenerator.showDetailMinorAttribute(context, "City", user!.city),
        WidgetGenerator.showDetailMinorAttribute(
            context, "DOB", parseDob(user!.dob)),
        WidgetGenerator.showDetailMinorAttribute(
            context, "Phone number", user!.phonenumber),
        WidgetGenerator.AlignTwoWidget(
            ButtonsGenerator.createButton(
                context,
                () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UploadDocumentPage()))
                    },
                "upload document",
                backgroundColor: Colors.black12),
            ButtonsGenerator.createButton(
                context,
                () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ViewDocumentPage()))
                    },
                "view document",
                backgroundColor: Colors.black12))
      ],
    );
  }

  Widget createTitle(String label, String title) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  String parseDob(String dob) {
    try {
      var dt = DateTime.parse(dob);
      return DateFormat("yyyy-MM-dd").format(dt);
    } on FormatException catch (e) {
      print(e);
      return DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }
}
