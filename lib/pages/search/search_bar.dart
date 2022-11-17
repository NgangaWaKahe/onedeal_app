import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:onedeal_app/pages/search/search_row.dart';
import 'package:onedeal_app/util/widget_generator.dart';

import '../../model/car.dart';
import '../../services/car.dart';
import '../car/car_row.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int positions = 3;

  final int limit = 15;

  int offset = 0;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _filter = TextEditingController();

  bool isLoading = false;

  final CarService service = CarService();

  List<Car> searchResults = [];

  final Widget _appBarTitle = WidgetGenerator.createPageTitle('Search');

  String searchText = "";

  Color notificationColor = Colors.white;

  String search = "";

  @override
  void initState() {
    super.initState();

    //     _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     print("_getData");
    //     _getMoreData();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onRefresh() {
    offset = 0;
    searchResults.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _appBarTitle,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(child: Stack(children: getItems(context))),
    );
  }

  List<Widget> getItems(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(createListView(context));

    if (isLoading) {
      var modal = Stack(
        children: const [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
      widgets.add(modal);
    }

    return widgets;
  }

  void _getMoreData(String search) async {
    if (!isLoading) {
      if (this.mounted) {
        setState(() {
          isLoading = true;
        });
      }
      searchResults.clear();
      final response =
          await service.fetchFeature(50, offset, searchTerm: search);

      List<Car> tempList = [];
      tempList.addAll(response.transactions);

      if (this.mounted) {
        setState(() {
          isLoading = false;
          searchResults.addAll(tempList);
        });
      }
    }
  }

  Widget createListView(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 100,
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autocorrect: false,
              onChanged: (text) {
                if (text.length > 1) {
                  _getMoreData(text);
                }
              },
              controller: _filter,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 4, color: Theme.of(context).primaryColor)),
                  prefixIcon: Icon(Icons.search,
                      size: 24, color: Theme.of(context).primaryColor),
                  hintText: 'Search Cars'),
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 300,
                ),
                itemCount: searchResults.length,
                itemBuilder: (BuildContext ctx, index) {
                  return CarThumbnail(searchResults[index], false);
                }),
          ),
        )
      ],
    );
  }
}
