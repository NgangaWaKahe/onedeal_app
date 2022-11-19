import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onedeal_app/model/car.dart';
import 'package:onedeal_app/services/car.dart';
import 'package:onedeal_app/pages/car/car_row.dart';

import '../../model/category.dart';
import '../../model/results.dart';
import '../../services/car_metadata.dart';
import '../loading_screen.dart';
import '../search/search_bar.dart';
import 'infinite_scroll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final CarService service = CarService();
  final CarMetadataService metadataService = CarMetadataService();

  List<Category> categories = [];

  bool isLoading = false;

  final int limit = 15;

  final ScrollController _scrollController = ScrollController();

  final ScrollController _scrollLocController = ScrollController();

  int offset = 0;

  List<Car> premiumCars = [];

  List<Car> cars = [];

  var counter = 0;

  Category? selectedItem;

  int allOtherOffset = 0;

  bool fetchedCategories = false;

  @override
  void initState() {
    super.initState();

    _getData();
  }

  _getData() async {
    if (!isLoading) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      List<Future<ResponseResult>> requests = [
        service.fetchFeature(10, offset,
            selectedItem: selectedItem, isPremium: true),
        service.fetchFeature(20, allOtherOffset, selectedItem: selectedItem),
      ];
      if (!fetchedCategories) {
        requests.add(metadataService.fetchCategory());
      }

      List<ResponseResult> responses = await Future.wait(requests);

      if (responses[0].respondCode == 401 || responses[1].respondCode == 401) {
        Navigator.popAndPushNamed(context, '/login');
      }

      List<Car> tempList = [];
      offset += responses[0].transactions.length;
      for (int i = 0; i < responses[0].transactions.length; i++) {
        tempList.add(responses[0].transactions[i]);
      }

      List<Car> allOtherCars = [];
      allOtherOffset += responses[1].transactions.length;
      for (int i = 0; i < responses[1].transactions.length; i++) {
        allOtherCars.add(responses[1].transactions[i]);
      }

      List<Category> tempCategories = [];
      if (!fetchedCategories) {
        for (int i = 0; i < responses[2].transactions.length; i++) {
          tempCategories.add(responses[2].transactions[i]);
        }
      }

      if (mounted) {
        setState(() {
          isLoading = false;
          premiumCars.addAll(tempList);
          cars.addAll(allOtherCars);
          if (!fetchedCategories) {
            fetchedCategories = true;
            categories.addAll(tempCategories);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Stack(children: buildView(context))));
  }

  List<Widget> buildView(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createHomeView(context));

    if (isLoading) {
      widgets.add(const LoadingScreen());
    }
    return widgets;
  }

  Widget createHomeView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Welcome',
                style: TextStyle(
                    fontFamily: 'Opensans',
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF116D51)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Container(
            padding: const EdgeInsets.only(left: 20.0),
            height: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color(0xFFF9F9F9)),
            child: Center(
              child: TextField(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchPage()));
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  hintText: 'What would you like to discover?',
                  hintStyle: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 15.0,
                      color: Colors.grey.withOpacity(0.8)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 0.0),
          child: Container(
            height: 60.0,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              ...categories.map((e) {
                counter++;
                if (counter <= 3) {
                  return _buildItem(e, counter);
                } else {
                  counter = 0;
                  return _buildItem(e, counter);
                }
              }).toList(),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Best Cars',
                    style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 20.0,
                    )),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  highlightColor: Colors.black,
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const InfinitePremiseScrollPage(true)))
                  },
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            height: 300.0,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: premiumCars.length,
              itemBuilder: (BuildContext context, int index) {
                return CarThumbnail(premiumCars[index], false);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Browser',
                    style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 20.0,
                    )),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  highlightColor: Colors.black,
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const InfinitePremiseScrollPage(false)))
                  },
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
          child: Container(
            height: 300.0,
            child: ListView.builder(
              controller: _scrollLocController,
              scrollDirection: Axis.vertical,
              itemCount: cars.length,
              itemBuilder: (BuildContext context, int index) {
                return CarThumbnail(cars[index], true);
              },
            ),
          ),
        )
      ],
    );
  }

  _buildItem(Category cat, int count) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 15.0, top: 10.0, bottom: 10.0, left: 4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: switchHighlight(cat),
            boxShadow: [
              BoxShadow(
                  blurRadius: 4.0, spreadRadius: 2.0, color: switchShadow(cat))
            ]),
        height: 50.0,
        width: 125.0,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedItem = cat;
              allOtherOffset = 0;
              offset = 0;
              premiumCars.clear();
              cars.clear();
              isLoading = false;
              _getData();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              cat.name,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: switchHighlightColor(cat)),
            ),
          ),
        ),
      ),
    );
  }

  switchHighlight(prodName) {
    if (prodName == selectedItem) {
      return const Color(0xFF116D51);
    } else {
      return Colors.grey.withOpacity(0.3);
    }
  }

  switchHighlightColor(prodName) {
    if (prodName == selectedItem) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  switchShadow(prodName) {
    if (prodName == selectedItem) {
      return const Color(0xFF116D51).withOpacity(0.4);
    } else {
      return Colors.transparent;
    }
  }
}
