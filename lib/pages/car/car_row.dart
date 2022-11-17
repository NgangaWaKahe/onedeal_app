import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/model/car.dart';

import 'detail.dart';

class CarThumbnail extends StatelessWidget {
  final Car car;

  final bool useFullWidth;

  const CarThumbnail(this.car, this.useFullWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  _buildCard(BuildContext context) {
    final double imageWidth =
        useFullWidth ? MediaQuery.of(context).size.width - 50 : 200.0;
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => DetailPage(car)));
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: 275.0,
                width: imageWidth,
                child: CachedNetworkImage(
                  imageUrl: car.imageUrl[0],
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
                top: 10.0,
                left: 10.0,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black.withOpacity(0.2)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.star,
                              color: Colors.white, size: 12.0),
                        ],
                      )),
                    ),
                    const SizedBox(width: 50.0),
                    const Text(
                      'More',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Opensans'),
                    ),
                    const SizedBox(width: 7.0),
                    //this should be an iconbutton in a real app.
                    const Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 25.0)
                  ],
                ),
              ),
              Positioned(
                top: 225.0,
                left: 10.0,
                child: Container(
                  width: 150.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(car.brand,
                          style: const TextStyle(
                              fontFamily: 'Opensans',
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Text(car.make,
                          style: const TextStyle(
                              fontFamily: 'Opensans',
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
