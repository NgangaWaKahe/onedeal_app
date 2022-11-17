import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconGenerator {
  // https://fontawesome.com/icons?d=gallery&m=free
  static List<FaIcon> icons = [
    FaIcon(FontAwesomeIcons.gamepad),
    FaIcon(FontAwesomeIcons.adjust),
    FaIcon(FontAwesomeIcons.bandAid),
    FaIcon(FontAwesomeIcons.balanceScaleLeft),
    FaIcon(FontAwesomeIcons.bahai),
    FaIcon(FontAwesomeIcons.bomb),
    FaIcon(FontAwesomeIcons.book),
    FaIcon(FontAwesomeIcons.brain),
    FaIcon(FontAwesomeIcons.bullhorn),
    FaIcon(FontAwesomeIcons.busAlt),
    FaIcon(FontAwesomeIcons.cameraRetro),
    FaIcon(FontAwesomeIcons.capsules),
    FaIcon(FontAwesomeIcons.carBattery),
    FaIcon(FontAwesomeIcons.caravan),
    FaIcon(FontAwesomeIcons.cat),
    FaIcon(FontAwesomeIcons.cashRegister),
    FaIcon(FontAwesomeIcons.chair),
    FaIcon(FontAwesomeIcons.chartArea),
    FaIcon(FontAwesomeIcons.cloudMeatball),
    FaIcon(FontAwesomeIcons.cocktail),
    FaIcon(FontAwesomeIcons.cloudversify),
    FaIcon(FontAwesomeIcons.coins),
    FaIcon(FontAwesomeIcons.gamepad),
    FaIcon(FontAwesomeIcons.crow),
    FaIcon(FontAwesomeIcons.delicious),
    FaIcon(FontAwesomeIcons.gamepad),
    FaIcon(FontAwesomeIcons.diceD6),
    FaIcon(FontAwesomeIcons.diceD20),
    FaIcon(FontAwesomeIcons.digitalTachograph),
    FaIcon(FontAwesomeIcons.dna),
    FaIcon(FontAwesomeIcons.drum),
    FaIcon(FontAwesomeIcons.drumSteelpan),
    FaIcon(FontAwesomeIcons.ellipsisV),
    FaIcon(FontAwesomeIcons.featherAlt),
    FaIcon(FontAwesomeIcons.fingerprint),
    FaIcon(FontAwesomeIcons.fingerprint),
    FaIcon(FontAwesomeIcons.fireExtinguisher),
    FaIcon(FontAwesomeIcons.firstdraft),
    FaIcon(FontAwesomeIcons.hippo),
    FaIcon(FontAwesomeIcons.horse),
    FaIcon(FontAwesomeIcons.hotjar),
    FaIcon(FontAwesomeIcons.houseDamage),
    FaIcon(FontAwesomeIcons.houzz),
    FaIcon(FontAwesomeIcons.houseUser),
    FaIcon(FontAwesomeIcons.horseHead),
    FaIcon(FontAwesomeIcons.hotel),
    FaIcon(FontAwesomeIcons.info),
    FaIcon(FontAwesomeIcons.lemon),
    FaIcon(FontAwesomeIcons.lightbulb),
    FaIcon(FontAwesomeIcons.line),
    FaIcon(FontAwesomeIcons.memory),
    FaIcon(FontAwesomeIcons.moneyBill),
    FaIcon(FontAwesomeIcons.piedPiper),
    FaIcon(FontAwesomeIcons.piggyBank),
    FaIcon(FontAwesomeIcons.productHunt),
    FaIcon(FontAwesomeIcons.pumpMedical),
    FaIcon(FontAwesomeIcons.quoteRight),
    FaIcon(FontAwesomeIcons.road),
    FaIcon(FontAwesomeIcons.shower),
    FaIcon(FontAwesomeIcons.shippingFast),
    FaIcon(FontAwesomeIcons.shoePrints),
    FaIcon(FontAwesomeIcons.simCard),
    FaIcon(FontAwesomeIcons.shoePrints),
    FaIcon(FontAwesomeIcons.snowplow),
    FaIcon(FontAwesomeIcons.socks),
    FaIcon(FontAwesomeIcons.paintRoller),
    FaIcon(FontAwesomeIcons.oilCan),
    FaIcon(FontAwesomeIcons.palette),
    FaIcon(FontAwesomeIcons.socks),
    FaIcon(FontAwesomeIcons.pepperHot),
    FaIcon(FontAwesomeIcons.percent),
    FaIcon(FontAwesomeIcons.prescription),
    FaIcon(FontAwesomeIcons.rainbow),
  ];
  static Widget getIcon(String input) {
    var iconPos = input.hashCode % icons.length;
    return icons[iconPos];
  }

  static Color getColor(String input) {
    var shade = input.hashCode % 255;
    return Color.fromRGBO(shade, shade, 255, 0.9);
  }

  static Widget paymentIcon(String input) {
    var iconPos = input.hashCode % icons.length;
    return FaIcon(icons[iconPos].icon, size: 40);
  }

  static Widget getCalendarIcon() {
    return FaIcon(FontAwesomeIcons.calendarMinus);
  }

  static Widget getUserIcon(Color color) {
    return FaIcon(FontAwesomeIcons.user, size: 30, color: color);
  }

  static Widget getUserAdmin() {
    return FaIcon(FontAwesomeIcons.usersCog);
  }

  static var amentiesLookup = {
    "Leather seats": FontAwesomeIcons.chair,
    "Heat and Air Conditioning": FontAwesomeIcons.fan,
    "Sunroof/moonroof": FontAwesomeIcons.cloudSun,
    "Heated seats": FontAwesomeIcons.planeArrival,
    "Backup camera": FontAwesomeIcons.cameraRetro,
    "Navigation system": FontAwesomeIcons.mapLocation,
    "Bluetooth": FontAwesomeIcons.bluetoothB,
    "Remote start": FontAwesomeIcons.recycle,
    "Blind spot monitoring": FontAwesomeIcons.trafficLight,
    "Third-row seating": FontAwesomeIcons.squarePollVertical,
    "Apple CarPlay/Android Auto": FontAwesomeIcons.radio,
    "Parking Cameras": FontAwesomeIcons.squareParking,
    "Power windows": FontAwesomeIcons.windowMaximize,
    "Adaptive cruise control": FontAwesomeIcons.carTunnel,
    'Wifi': FontAwesomeIcons.wifi,
  };

  static Widget getCarFeatureIcon(BuildContext context, String amenties) {
    var icon = amentiesLookup[amenties];
    if (icon == null) {
      return FaIcon(FontAwesomeIcons.film,
          color: Theme.of(context).primaryColor, size: 40);
    }
    return FaIcon(icon, color: Theme.of(context).highlightColor, size: 40);
  }
}
