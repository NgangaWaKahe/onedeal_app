import 'dart:ffi';

import 'package:onedeal_app/services/app.dart';
import 'package:onedeal_app/util/formatter.dart';

class CarFeature {
  String id = "";
  String name = "";

  CarFeature(this.id, this.name);
}

class Car {
  String id = "";
  String categoryID = "";
  String category = "";
  String brandID = "";
  String brand = "";
  String makeID = "";
  String make = "";
  String engineType = "";
  double engineSize = 0;
  String transmission = "";
  double productionYear = 0;
  double mileage = 0;
  String color = "";
  double capacity = 0;
  String plateNumber = "";
  String ownerID = "";
  double price = 0;
  List<String> imageUrl = [];
  List<CarFeature> carFeature = [];

  Car(
      this.id,
      this.categoryID,
      this.category,
      this.brandID,
      this.brand,
      this.makeID,
      this.make,
      this.engineType,
      this.engineSize,
      this.transmission,
      this.productionYear,
      this.mileage,
      this.color,
      this.capacity,
      this.plateNumber,
      this.ownerID,
      this.price,
      this.imageUrl,
      this.carFeature);

  Car.empty() {
    id = "";
  }

  static Car retrieveCar(dynamic x) {
    var car = Car.empty();
    car.id = x["id"];
    car.categoryID = x["car_category_id"];
    car.category = x["car_category"];
    car.brand = x["car_brand"];
    car.brandID = x["car_brand_id"];
    car.makeID = x["car_make_id"];
    car.make = x["car_make"];
    car.engineType = x["engine_type"];
    car.engineSize = Formatter.convertToDouble(x["engine_size"]);
    car.transmission = x["transmission"];
    car.productionYear = Formatter.convertToDouble(x["product_year"]);
    car.mileage = Formatter.convertToDouble(x["mileage"]);
    car.color = x["color"];
    car.capacity = Formatter.convertToDouble(x["capacity"]);
    car.plateNumber = x["plate_number"];
    car.ownerID = x["owner_id"];
    car.price = Formatter.convertToDouble(x["pricing"]);
    for (var w in x["images"]) {
      var host = AppService.ServiceImageURL;
      var url = "$host?name=$w";
      car.imageUrl.add(url);
    }
    for (var w in x["car_features"]) {
      car.carFeature.add(CarFeature(w["id"], w["name"]));
    }
    return car;
  }
}
