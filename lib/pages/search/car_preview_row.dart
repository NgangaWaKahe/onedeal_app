import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/car.dart';
import '../car/detail.dart';

class CarPreviewRow extends StatelessWidget {
  final Car foundCar;
  final bool showCarBrandMake;
  final ScrollController _scrollController = ScrollController();

  CarPreviewRow(this.foundCar, this.showCarBrandMake, {super.key});

  @override
  Widget build(BuildContext context) {
    return buildRow(context);
  }

  Widget buildRow(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          showCarBrandMake
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10, 5, 0),
                  child: Text(
                    foundCar.brand,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ))
              : const SizedBox(),
          showCarBrandMake
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 10, 0, 0),
                  child: Text(
                    foundCar.make,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ))
              : const SizedBox(),
        ]),
        GestureDetector(
          onTap: () {
            onClick(context, foundCar);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 150.0,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: foundCar.imageUrl.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildSingleImage(foundCar.imageUrl[index]);
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  void onClick(BuildContext context, final Car car) async {
    Navigator.of(context).push(MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return DetailPage(car);
        },
        fullscreenDialog: true));
  }

  Widget buildSingleImage(String url) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              width: 100.0,
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
