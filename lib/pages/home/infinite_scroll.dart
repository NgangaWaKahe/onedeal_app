import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/model/car.dart';
import 'package:onedeal_app/services/car.dart';
import 'package:onedeal_app/model/results.dart';
import 'package:onedeal_app/pages/car/car_row.dart';

import '../../model/category.dart';

class InfinitePremiseScrollPage extends StatefulWidget {
  final bool isPremium;

  const InfinitePremiseScrollPage(this.isPremium);

  @override
  InfinitePremiseScrollPageState createState() =>
      InfinitePremiseScrollPageState(isPremium);
}

class InfinitePremiseScrollPageState extends State<InfinitePremiseScrollPage> {
  final CarService service = CarService();

  bool isLoading = false;

  final int limit = 20;

  ScrollController _scrollController = new ScrollController();

  int offset = 0;

  List<Car> cars = [];

  final bool isPremium;

  InfinitePremiseScrollPageState(this.isPremium);

  Category? selectedCat;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("_getData");
        _getData();
      }
    });

    _getData();
  }

  Future<ResponseResult<Car>> getData() async {
    if (isPremium) {
      return await service.fetchFeature(limit, offset, isPremium: true);
    }
    return await service.fetchFeature(limit, offset);
  }

  _getData() async {
    if (!isLoading) {
      if (this.mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final response = await getData();
      if (response.respondCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text("Error try again")));
      } else {
        List<Car> tempList = [];
        offset += response.transactions.length;
        for (int i = 0; i < response.transactions.length; i++) {
          tempList.add(response.transactions[i]);
        }

        if (this.mounted) {
          setState(() {
            isLoading = false;
            cars.addAll(tempList);
          });
        }
      }
    }
  }

  Widget createScrollView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            mainAxisExtent: 300,
          ),
          itemCount: cars.length,
          itemBuilder: (BuildContext ctx, index) {
            return CarThumbnail(cars[index], false);
          }),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createScrollView(context));

    if (isLoading) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      widgets.add(modal);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(children: getItems(context)),
    );
  }
}
