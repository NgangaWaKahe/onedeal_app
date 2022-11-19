import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onedeal_app/services/login.dart';

import '../action_screen.dart';
import '../loading_screen.dart';
import 'card_picture.dart';

class UploadDocumentPage extends StatefulWidget {
  const UploadDocumentPage({super.key});

  @override
  _UploadDocumentPageState createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  List<String> _images = [];

  bool isLoading = false;

  final LoginService service = LoginService();

  bool finishedSendingVal = false;

  String feedbackMsg = "";

  Color feedbackColor = Colors.black;

  bool successful = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Upload Docs",
              style: TextStyle(fontFamily: 'Opensans')),
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

    if (finishedSendingVal) {
      widgets.add(ActionRespondScreen(successful, feedbackColor, feedbackMsg));
    }

    return widgets;
  }

  void showMessage(String message, bool succesful,
      [MaterialColor color = Colors.red]) {
    setState(() {
      isLoading = false;
      finishedSendingVal = true;
      successful = succesful;
      feedbackMsg = message;
      feedbackColor = succesful ? Colors.green : Colors.red;
    });
  }

  Widget createView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          const Text('Upload a driving licence and proof of identify',
              style: TextStyle(fontSize: 17.0)),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 400,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                      CardPicture(
                        onTap: () async {
                          try {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (image == null) return;
                            final imageTemp = File(image.path);
                            setState(() {
                              _images.add(image.path);
                            });
                          } on PlatformException catch (e) {
                            print('Failed to pick image: $e');
                          }
                        },
                      )
                    ] +
                    _images
                        .map((String path) => CardPicture(
                              imagePath: path,
                            ))
                        .toList()),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.indigo,
                            gradient: LinearGradient(colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor,
                              Colors.white
                            ]),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: RawMaterialButton(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          onPressed: () async {
                            if (_images.isEmpty) {
                              return;
                            }
                            // show loader
                            setState(() {
                              isLoading = true;
                            });

                            service.uploadPhotos(_images).then((value) async {
                              if (value.respondCode == 200) {
                                showMessage("successful uploaded photos", true,
                                    Colors.blue);
                              } else {
                                showMessage("failed uploading contact support",
                                    false, Colors.red);
                              }
                            });
                          },
                          child: const Center(
                              child: Text(
                            'UPLOAD',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          )),
                        )),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
