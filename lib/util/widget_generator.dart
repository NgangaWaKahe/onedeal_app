import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'icon_generator.dart';

class WidgetGenerator {
  static TextStyle timeStyles = const TextStyle(
      fontSize: 15.0,
      fontFamily: 'Opensans',
      color: Color(0xFF6A6A6A),
      fontWeight: FontWeight.bold);

  static Widget createPageTitle(final String title) {
    return Text(title,
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold));
  }

  static Text createTextBox(String text,
      [Color color = Colors.grey,
      double fontSize = 15.0,
      FontWeight fontWeight = FontWeight.bold]) {
    return Text(
      text.toString(),
      overflow: TextOverflow.fade,
      maxLines: 2,
      style:
          TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }

  static Widget showMinorAttribute(
      BuildContext context, String label, String value,
      [double inputFontSize = 24.0, int maxLines = 1]) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                label,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 2),
              Flexible(
                  child: Text(
                value ?? "",
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: inputFontSize,
                    fontWeight: FontWeight.bold),
              ))
            ]),
          ],
        ));
  }

  static Widget showDetailMinorAttribute(
      BuildContext context, String label, String value,
      [double inputFontSize = 24.0, int maxLines = 1]) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(label,
                  style: const TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 15.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              Flexible(
                  child: Text(
                value ?? "",
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: inputFontSize,
                    fontWeight: FontWeight.bold),
              ))
            ]),
            const Divider(
              color: Colors.black,
            ),
          ],
        ));
  }

  static Widget showActionPanel(
      BuildContext context, String label, Function() fn,
      [double inputFontSize = 24.0, int maxLines = 1]) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(label,
                  style: const TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 15.0,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              Flexible(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: fn,
                      child: Text("Secure Now".toUpperCase(),
                          style: const TextStyle(fontSize: 14))))
            ]),
            const Divider(
              color: Colors.black,
            ),
          ],
        ));
  }

  static Widget getDateSelector(BuildContext context, DateTime start,
      DateTime end, Function(List<DateTime>) onSelection) {
    return MaterialButton(
        onPressed: () async {
          DateTimeRange? dates = await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(start: start, end: end),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 600)),
          );

          if (dates != null) {
            onSelection([dates.start, dates.end]);
          }
        },
        child: IconButton(
          color: Theme.of(context).primaryColor,
          icon: IconGenerator.getCalendarIcon(),
          onPressed: () async {
            DateTimeRange? dates = await showDateRangePicker(
              context: context,
              initialDateRange: DateTimeRange(start: start, end: end),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 600)),
            );

            if (dates != null) {
              onSelection([dates.start, dates.end]);
            }
          },
        ));
  }

  static Widget timeCreator(
      BuildContext context,
      double width,
      height,
      String label,
      TextEditingController controller,
      Function onSelected,
      int index,
      bool isOpening) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(5),
          child: Text(label, style: timeStyles)),
      InkWell(
        onTap: () {
          onSelected(context, controller, index, isOpening);
        },
        child: Container(
          width: width / 5,
          // height: height / 20,
          margin: const EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: TextFormField(
            style: const TextStyle(fontFamily: 'Opensans', fontSize: 16),
            textAlign: TextAlign.center,
            enabled: false,
            keyboardType: TextInputType.text,
            controller: controller,
            decoration: const InputDecoration(
                disabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(5)),
          ),
        ),
      )
    ]);
  }

  static Widget createDateField(
      BuildContext context,
      String hintLabel,
      TextEditingController controller,
      TextStyle textStyle,
      Future Function(BuildContext, String, TextEditingController) fn,
      [bool showSteps = true]) {
    return Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
        child: Column(children: [
          Row(children: <Widget>[
            Expanded(
                child: TextFormField(
              style: textStyle,
              enabled: false,
              decoration: InputDecoration(
                labelStyle: textStyle,
                helperStyle: textStyle,
                icon: const Icon(Icons.calendar_today),
                hintText: hintLabel,
                labelText: hintLabel,
              ),
              controller: controller,
              keyboardType: TextInputType.datetime,
            )),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              tooltip: 'Choose date',
              onPressed: (() {
                fn(context, controller.text, controller);
              }),
            )
          ])
        ]));
  }
}
