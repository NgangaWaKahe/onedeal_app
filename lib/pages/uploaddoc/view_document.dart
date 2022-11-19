import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onedeal_app/services/login.dart';

import '../../data/local_data.dart';
import '../../model/results.dart';
import '../../model/user.dart';
import '../../services/app.dart';
import '../action_screen.dart';
import '../loading_screen.dart';
import 'card_picture.dart';

class ViewDocumentPage extends StatefulWidget {
  const ViewDocumentPage({super.key});

  @override
  _ViewDocumentPageState createState() => _ViewDocumentPageState();
}

class _ViewDocumentPageState extends State<ViewDocumentPage> {
  bool isLoading = false;

  final LoginService service = LoginService();

  bool finishedSendingVal = false;

  String feedbackMsg = "";

  Color feedbackColor = Colors.black;

  bool successful = false;

  final DBHelper dbHelper = DBHelper();

  User? user;

  List<String> documentList = [];

  Map<String, String> httpHeader = {};

  @override
  void initState() {
    super.initState();

    dbHelper.getUsers().then((result) {
      if (mounted) {
        setState(() {
          if (result.length == 1) {
            user = result[0];
            isLoading = false;
            _getData();
          } else {
            Navigator.popAndPushNamed(context, '/login');
          }
        });
      }
    });

    AppService.getImageHttpHeader().then((value) {
      httpHeader = value;
    });
  }

  _getData() async {
    if (!isLoading) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      List<ResponseResult<String>> responses =
          await Future.wait([service.findDocument()]);

      if (responses[0].respondCode == 401) {
        Navigator.popAndPushNamed(context, '/login');
      }

      List<String> tempList = [];
      for (int i = 0; i < responses[0].transactions.length; i++) {
        tempList.add(responses[0].transactions[i]);
      }

      if (mounted) {
        setState(() {
          isLoading = false;
          documentList = tempList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text("View Docs", style: TextStyle(fontFamily: 'Opensans')),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(child: Stack(children: getItems(context))));
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createView(context));

    if (isLoading) {
      widgets.add(const LoadingScreen());
    }

    return widgets;
  }

  Widget createView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          const Text('Uploaded docs below', style: TextStyle(fontSize: 17.0)),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 400,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: documentList
                    .map((String path) => buildSingleImage(path))
                    .toList()),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget buildSingleImage(String url) {
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100.0,
          width: size.width * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: CachedNetworkImage(
            imageUrl: url,
            httpHeaders: httpHeader,
            imageBuilder: (context, imageProvider) => Container(
              width: size.width * .70,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ));
  }
}
