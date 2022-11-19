import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionRespondScreen extends StatelessWidget {
  final bool successful;
  final Color feedbackColor;
  final String feedbackMsg;

  const ActionRespondScreen(
      this.successful, this.feedbackColor, this.feedbackMsg,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.9,
          child: ModalBarrier(dismissible: false, color: Colors.white),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FaIcon(
              successful
                  ? FontAwesomeIcons.checkDouble
                  : FontAwesomeIcons.thumbsDown,
              color: feedbackColor,
              size: 60),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.all(5),
              child: Text(feedbackMsg,
                  style: const TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 30.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600))),
          const SizedBox(height: 10),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop(successful);
              },
              child: Container(
                height: 40.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black.withOpacity(0.7),
                ),
                child: const Center(
                    child: Text(
                  'Done',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )),
              ))
        ]),
      ],
    );
  }
}
