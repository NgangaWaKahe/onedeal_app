import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onedeal_app/model/car.dart';
import 'package:onedeal_app/model/rental.dart';
import 'package:onedeal_app/pages/reservation/reservation_detail.dart';
import 'package:onedeal_app/util/formatter.dart';

import '../../model/reservation.dart';

class RentalThumbnail extends StatelessWidget {
  final Rental rental;

  const RentalThumbnail(this.rental, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  _buildCard(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width - 20;
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: <Widget>[
              Container(
                height: 275.0,
                width: imageWidth,
                child: CachedNetworkImage(
                  imageUrl: rental.images[0],
                  imageBuilder: (context, imageProvider) => Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 275.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              //make the shade a bit deeper.
              Container(
                height: 275.0,
                width: imageWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.4)),
              ),
              Positioned(
                top: 200.0,
                left: 10.0,
                child: Container(
                  width: imageWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${rental.carBrand} ${rental.carMake}",
                          style: const TextStyle(
                              fontFamily: 'Opensans',
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Text(getDates(),
                          style: const TextStyle(
                              fontFamily: 'Opensans',
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Row(children: [
                        Text(
                            "${rental.status} ${Formatter.convertToDouble(rental.cost).toString()}",
                            style: const TextStyle(
                                fontFamily: 'Opensans',
                                fontSize: 17.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String getDates() {
    var start = DateFormat.yMMMd().format(rental.reservationStartDate);
    var end = DateFormat.yMMMd().format(rental.reservationEndDate);
    return "$start  $end";
  }
}
