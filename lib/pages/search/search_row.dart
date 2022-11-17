import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/car.dart';
import '../car/detail.dart';

class SearchRow extends StatelessWidget {
  final Car foundCar;

  const SearchRow(this.foundCar, {super.key});

  @override
  Widget build(BuildContext context) {
    return buildRow(context);
  }

  Widget buildRow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(context, foundCar);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: CachedNetworkImage(
                imageUrl: foundCar.imageUrl[0],
                imageBuilder: (context, imageProvider) => Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 15.0),
            Container(
              width: MediaQuery.of(context).size.width - 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          foundCar.brand,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          foundCar.make,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClick(BuildContext context, final Car car) async {
    Navigator.of(context).push(MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return DetailPage(car);
        },
        fullscreenDialog: true));
  }
}
